#!/bin/bash -e


function usage() {
    cat <<END_USAGE
Usage: $0 [options...]

Available options:
    <-i image_file> - indicates the path to the image file (e.g. -i /home/user/Download/file.img.xz)
END_USAGE
    exit 1
}

function msg() {
    echo " * $1"
}

if [[ -z "$1" ]]; then
    usage 1>&2
fi

if [[ $(id -u) -ne 0 ]]; then
    msg "please run as root"
    exit 1
fi

BOARD_DIR=$(dirname $0)

rkbin=${BOARD_DIR}/../../output/$(basename ${BOARD_DIR})/images/rkbin
rkdeveloptool=${rkbin}/tools/rkdeveloptool
flash_boot_loader=${BOARD_DIR}/flash-boot-loader.bin

while getopts "a:d:f:h:i:lm:n:o:p:s:w" o; do
    case "${o}" in
        i)
            DISK_IMG=${OPTARG}
            ;;
        *)
            usage 1>&2
            ;;
    esac
done

if [[ -z "${DISK_IMG}" ]]; then
    usage 1>&2
fi

if ! [[ -f "${DISK_IMG}" ]]; then
    echo "could not find image file $DISK_IMG"
    exit 1
fi

gunzip=$(which unpigz 2> /dev/null || which gunzip 2> /dev/null || true)
unxz=$(which unxz 2> /dev/null || true)

if [[ ${DISK_IMG} == *.gz ]]; then
    if [[ -z "$gunzip" ]]; then
        msg "make sure you have the gzip package installed"
        exit 1
    fi
    msg "decompressing the .gz compressed image"
    ${gunzip} -c "${DISK_IMG}" > "${DISK_IMG%???}"
    DISK_IMG=${DISK_IMG%???}
elif [[ ${DISK_IMG} == *.xz ]]; then
    if [[ -z "${unxz}" ]]; then
        msg "make sure you have the xz package installed"
        exit 1
    fi
    msg "decompressing the .xz compressed image"
    ${unxz} -T 0 -c "${DISK_IMG}" > "${DISK_IMG%???}"
    DISK_IMG=${DISK_IMG%???}
fi

if ${rkdeveloptool} ld 2>&1 | grep -iq maskrom; then
    msg "device in maskrom mode detected"
    msg "downloading flash bootloader"
    ${rkdeveloptool} db "${flash_boot_loader}"
elif ${rkdeveloptool} ld 2>&1 | grep -iq loader; then
    msg "device in loader mode detected"
else
    msg "make sure your device is connected and in maskrom or loader mode"
    exit 1
fi

msg "writing OS image to flash"
${rkdeveloptool} wl 0 "${DISK_IMG}"

msg "you can now reset your device!"
