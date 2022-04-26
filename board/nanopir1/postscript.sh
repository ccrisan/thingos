#!/bin/bash

cp ${BINARIES_DIR}/boot.scr ${BOOT_DIR}
cp ${BINARIES_DIR}/sun8i-h3-nanopi-r1.dtb ${BOOT_DIR}

mkdir -p ${BOOT_DIR}/overlays
cp ${BUILD_DIR}/linux-custom/arch/arm/boot/dts/overlays/*.dtbo ${BOOT_DIR}/overlays
cp ${BINARIES_DIR}/zImage ${BOOT_DIR}
cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${BOARD_DIR}/uEnv.txt ${BOOT_DIR}
