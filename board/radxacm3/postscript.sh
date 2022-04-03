#!/bin/bash

radxa_mkimage="${BUILD_DIR}/uboot-custom/tools/mkimage"
mainline_mkimage="${HOST_DIR}/bin/mkimage"
${radxa_mkimage} -n rk3568 -T rksd -d ${BOARD_DIR}/rk3566_ddr_1056MHz_v1.10.bin:${BINARIES_DIR}/u-boot-spl.bin ${BINARIES_DIR}/idbloader.img
${mainline_mkimage} -C none -A arm -T script -d ${BOARD_DIR}/boot.cmd ${BOOT_DIR}/boot.scr

cp -r ${BOARD_DIR}/firmware/* ${TARGET_DIR}/lib/firmware
mkdir -p ${TARGET_DIR}/vendor/etc
rm -f ${TARGET_DIR}/vendor/etc/firmware
ln -sf /lib/firmware ${TARGET_DIR}/vendor/etc/firmware

mkdir -p ${BOOT_DIR}/overlays
cp ${BINARIES_DIR}/rk3566-radxa-cm3-rpi-cm4-io.dtb ${BOOT_DIR}
cp ${BUILD_DIR}/linux-custom/arch/arm64/boot/dts/rockchip/overlay/*.dtbo ${BOOT_DIR}/overlays
cp ${BINARIES_DIR}/Image ${BOOT_DIR}
cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${BOARD_DIR}/uEnv.txt ${BOOT_DIR}
