#!/bin/sh

mkimage="${BUILD_DIR}/uboot-custom/tools/mkimage"
${mkimage} -n rk3568 -T rksd -d ${BOARD_DIR}/rk3566_ddr_1056MHz_v1.10.bin:${BINARIES_DIR}/u-boot-spl.bin ${BINARIES_DIR}/idbloader.img

mkdir ${BOOT_DIR}/extlinux
cp ${BOARD_DIR}/extlinux.conf ${BOOT_DIR}/extlinux

mkdir -p ${TARGET_DIR}/vendor/etc
cp -r ${BOARD_DIR}/firmware/* ${TARGET_DIR}/lib/firmware
ln -sf /lib/firmware /vendor/etc/firmware

cp ${BINARIES_DIR}/rk3566-radxa-cm3-rpi-cm4-io.dtb ${BOOT_DIR}
cp ${BINARIES_DIR}/Image ${BOOT_DIR}
