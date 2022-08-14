#!/bin/bash

radxa_mkimage="${BUILD_DIR}/uboot-custom/tools/mkimage"
${radxa_mkimage} -n rk3568 -T rksd -d ${BOARD_DIR}/rk3566_ddr_1056MHz_v1.10.bin:${BINARIES_DIR}/u-boot-spl.bin ${BINARIES_DIR}/idbloader.img

mkdir -p ${TARGET_DIR}/vendor/etc
rm -f ${TARGET_DIR}/vendor/etc/firmware
ln -sf /lib/firmware ${TARGET_DIR}/vendor/etc/firmware

mkdir -p ${BOOT_DIR}/overlays
cp ${BINARIES_DIR}/rk3566-radxa-cm3-rpi-cm4-io.dtb ${BOOT_DIR}
cp ${BUILD_DIR}/linux-custom/arch/arm64/boot/dts/rockchip/overlay/*.dtbo ${BOOT_DIR}/overlays
cp ${BINARIES_DIR}/boot.scr ${BOOT_DIR}
cp ${BINARIES_DIR}/Image ${BOOT_DIR}
cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${BOARD_DIR}/uEnv.txt ${BOOT_DIR}
