#!/bin/bash

RKBIN_DIR=${BINARIES_DIR}/rkbin

# First stage boot loader
mkimage="${BUILD_DIR}/uboot-custom/tools/mkimage"
${mkimage} -n rk3399 -T rksd -d ${RKBIN_DIR}/bin/rk33/rk3399_ddr_800MHz_v1.27.bin ${BINARIES_DIR}/idbloader.img
cat ${RKBIN_DIR}/bin/rk33/rk3399_miniloader_v1.26.bin >> ${BINARIES_DIR}/idbloader.img

# U-boot
${RKBIN_DIR}/tools/loaderimage --pack --uboot ${BINARIES_DIR}/u-boot-dtb.bin ${BINARIES_DIR}/uboot.img 0x200000 --size 1024 1

# Trust image
cat >${BINARIES_DIR}/RK3399TRUST.ini <<EOF
[VERSION]
MAJOR=1
MINOR=0
[BL30_OPTION]
SEC=0
[BL31_OPTION]
SEC=1
PATH=${RKBIN_DIR}/bin/rk33/rk3399_bl31_v1.35.elf
ADDR=0x00040000
[BL32_OPTION]
SEC=0
[BL33_OPTION]
SEC=0
[OUTPUT]
PATH=${BINARIES_DIR}/trust.img
EOF
${RKBIN_DIR}/tools/trust_merger ${BINARIES_DIR}/RK3399TRUST.ini

# Wi-Fi firmware needs to be at `/system/etc/firmware` for some reason
mkdir -p ${TARGET_DIR}/system/etc
rm -f ${TARGET_DIR}/system/etc/firmware
ln -sf /lib/firmware ${TARGET_DIR}/system/etc/firmware

# Needed to set Bluetooth address
cp ${BUILD_DIR}/bluez5_utils-*/tools/bdaddr ${TARGET}/usr/libexec

# Boot partition files
mkdir -p ${BOOT_DIR}/overlays
cp ${BINARIES_DIR}/rk3399-rock-pi-4b.dtb ${BOOT_DIR}
cp ${BUILD_DIR}/linux-custom/arch/arm64/boot/dts/rockchip/overlay/*.dtbo ${BOOT_DIR}/overlays
cp ${BINARIES_DIR}/boot.scr ${BOOT_DIR}
cp ${BINARIES_DIR}/Image ${BOOT_DIR}
cp ${BOARD_DIR}/extlinux.conf ${BOOT_DIR}
cp ${BOARD_DIR}/hw_intfc.conf ${BOOT_DIR}
cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${BOARD_DIR}/uEnv.txt ${BOOT_DIR}
