#!/bin/bash -e

# optional env vars:
#  THINGOS_LOOP_DEV=/dev/loop0
#  THINGOS_NAME=thingOS
#  THINGOS_SHORT_NAME=thingos
#  THINGOS_PREFIX=thing
#  THINGOS_VERSION=3.14.15


test -n "$1" || { echo "Usage: $0 <board>"; exit 1; }
test $(id -u) -eq 0 || { echo "This script needs to be run as root."; exit 1; }

function msg() {
    echo " * $1"
}

set -a

BOARD=$1

# Under BR make invocation, ${BINARIES_DIR} would be automatically set to the images dir.
# For the scope of this script which is run outside of the BR make environment, we must set it manually.
BINARIES_DIR=$(dirname $0)/../../output/${BOARD}/images/
BOARD_DIR=$(dirname $0)/../../board/${BOARD}
COMMON_DIR=$(dirname $0)/../../board/common

BOOT_START=${BOOT_START:-1}  # MB

BOOT_SRC=${BINARIES_DIR}/boot
BOOT=${BINARIES_DIR}/.boot
BOOT_IMG=${BINARIES_DIR}/boot.img
BOOT_SIZE="30"  # MB - reserved up to 100 MB

ROOT_START="100"  # MB
ROOT_SRC=${BINARIES_DIR}/rootfs.tar
ROOT=${BINARIES_DIR}/.root
ROOT_IMG=${BINARIES_DIR}/root.img
ROOT_SIZE="200"  # MB

GUARD_SIZE="10"  # MB
DISK_SIZE=$((ROOT_START + ROOT_SIZE + GUARD_SIZE))

OS_NAME=$(source ${COMMON_DIR}/overlay/etc/version && echo ${OS_SHORT_NAME})

test -s ${BOARD_DIR}/board.conf && source ${BOARD_DIR}/board.conf

# "-f", unless a /dev/loopX is specified
LOOP_DEV=${THINGOS_LOOP_DEV:--f}

function cleanup_on_exit() {
    set +e

    umount ${loop_dev}* 2>/dev/null
    losetup -d ${loop_dev} 2>/dev/null
}


# boot filesystem
msg "creating boot loop device ${LOOP_DEV}"
dd if=/dev/zero of=${BOOT_IMG} bs=1M count=${BOOT_SIZE}
loop_dev=$(losetup --show ${LOOP_DEV} ${BOOT_IMG})

trap cleanup_on_exit EXIT

msg "creating boot filesystem"
mkfs.vfat -F16 ${loop_dev}

msg "mounting boot loop device"
mkdir -p ${BOOT}
mount ${loop_dev} ${BOOT}

msg "copying boot filesystem contents"
cp -r ${BOOT_SRC}/* ${BOOT}
sync

msg "unmounting boot filesystem"
umount ${BOOT}

msg "destroying boot loop device ${loop_dev}"
losetup -d ${loop_dev}
sync

# root filesystem
msg "creating root loop device ${LOOP_DEV}"
dd if=/dev/zero of=${ROOT_IMG} bs=1M count=${ROOT_SIZE}
loop_dev=$(losetup --show ${LOOP_DEV} ${ROOT_IMG})

msg "creating root filesystem"
mkfs.ext4 ${loop_dev}
tune2fs -O^has_journal ${loop_dev}

msg "mounting root loop device"
mkdir -p ${ROOT}
mount ${loop_dev} ${ROOT}

msg "copying root filesystem contents"
tar -xpsf ${ROOT_SRC} -C ${ROOT}

# set internal OS name, prefix and version according to env variables
if [ -f ${ROOT}/etc/version ]; then
    if [ -n "${THINGOS_NAME}" ]; then
        msg "setting OS name to ${THINGOS_NAME}"
        sed -ri "s/OS_NAME=\".*\"/OS_NAME=\"${THINGOS_NAME}\"/" ${ROOT}/etc/version
    fi
    if [ -n "${THINGOS_SHORT_NAME}" ]; then
        msg "setting OS short name to ${THINGOS_SHORT_NAME}"
        sed -ri "s/OS_SHORT_NAME=\".*\"/OS_SHORT_NAME=\"${THINGOS_SHORT_NAME}\"/" ${ROOT}/etc/version
    fi
    if [ -n "${THINGOS_PREFIX}" ]; then
        msg "setting OS prefix to ${THINGOS_PREFIX}"
        sed -ri "s/OS_PREFIX=\".*\"/OS_PREFIX=\"${THINGOS_PREFIX}\"/" ${ROOT}/etc/version
    fi
    if [ -n "${THINGOS_VERSION}" ]; then
        msg "setting OS version to ${THINGOS_VERSION}"
        sed -ri "s/OS_VERSION=\".*\"/OS_VERSION=\"${THINGOS_VERSION}\"/" ${ROOT}/etc/version
    fi
fi

msg "unmounting root filesystem"
umount ${ROOT}

msg "destroying root loop device ${loop_dev}"
losetup -d ${loop_dev}
sync

DISK_IMG=${BINARIES_DIR}/disk.img
BOOT_IMG=${BINARIES_DIR}/boot.img
ROOT_IMG=${BINARIES_DIR}/root.img

if ! [ -r ${BOOT_IMG} ]; then
    echo "boot image missing"
    exit -1
fi

if ! [ -r ${ROOT_IMG} ]; then
    echo "root image missing"
    exit -1
fi

# disk image
msg "creating disk loop device ${LOOP_DEV}"
dd if=/dev/zero of=${DISK_IMG} bs=1M count=${DISK_SIZE}
if [[ -n "${BOOT_BIN}" ]]; then
    for boot_bin in "${BOOT_BIN[@]}"; do
        IFS=@ boot_bin=(${boot_bin}); unset IFS
        bin=${boot_bin[0]}
        seek=${boot_bin[1]}
        msg "copying boot binary ${bin} @ ${seek}"
        dd conv=notrunc if=${bin} of=${DISK_IMG} bs=512 seek=${seek}
    done
fi
loop_dev=$(losetup --show ${LOOP_DEV} ${DISK_IMG})

msg "partitioning disk"
set +e
PART_TABLE_TYPE=${PART_TABLE_TYPE:-dos}
if [[ ${PART_TABLE_TYPE} == dos ]]; then
    fdisk -u=sectors ${loop_dev} <<END
o
n
p
1
$((BOOT_START * 2048))
+${BOOT_SIZE}M
n
p
2
$((ROOT_START * 2048))
+${ROOT_SIZE}M

t
1
e
a
1
w
END
elif [[ ${PART_TABLE_TYPE} == gpt ]]; then
    fdisk -u=sectors ${loop_dev} <<END
g
n
1
$((BOOT_START * 2048))
+${BOOT_SIZE}M
n
2
$((ROOT_START * 2048))
+${ROOT_SIZE}M
t
1
1
w
END
else
    msg "unknown partition table type ${PART_TABLE_TYPE}"
    exit 1
fi
set -e
sync

msg "reading partition offsets"
boot_offs=$(fdisk -u=sectors -l ${loop_dev} | grep -E 'loop([[:digit:]])+p1' | tr -d '*' | tr -s ' ' | cut -d ' ' -f 2)
root_offs=$(fdisk -u=sectors -l ${loop_dev} | grep -E 'loop([[:digit:]])+p2' | tr -d '*' | tr -s ' ' | cut -d ' ' -f 2)

msg "destroying disk loop device (${loop_dev})"
losetup -d ${loop_dev}

msg "creating boot loop device"
loop_dev=$(losetup --show -o $((${boot_offs} * 512)) ${LOOP_DEV} ${DISK_IMG})

msg "copying boot image"
dd if=${BOOT_IMG} of=${loop_dev}
sync

msg "destroying boot loop device (${loop_dev})"
losetup -d ${loop_dev}

msg "creating root loop device"
loop_dev=$(losetup --show -o $((${root_offs} * 512)) ${LOOP_DEV} ${DISK_IMG})
sync

msg "copying root image"
dd if=${ROOT_IMG} of=${loop_dev}
sync

msg "destroying root loop device ${loop_dev}"
losetup -d ${loop_dev}
sync

mv ${DISK_IMG} $(dirname ${DISK_IMG})/${OS_NAME}-${BOARD}.img
DISK_IMG=$(dirname ${DISK_IMG})/${OS_NAME}-${BOARD}.img

msg "$(realpath "${DISK_IMG}") is ready"
