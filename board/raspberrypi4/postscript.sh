#!/bin/sh

RPI_FW_DIR=${TARGET}/../images/rpi-firmware

mkdir -p ${BOOT_DIR}/overlays

cp ${BOARD_DIR}/config.txt ${BOOT_DIR}
cp ${BOARD_DIR}/cmdline.txt ${BOOT_DIR}
cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${IMG_DIR}/zImage ${BOOT_DIR}
cp ${IMG_DIR}/*.dtb ${BOOT_DIR}
cp ${RPI_FW_DIR}/start*.elf ${BOOT_DIR}
cp ${RPI_FW_DIR}/fixup*.dat ${BOOT_DIR}
cp ${RPI_FW_DIR}/overlays/*.dtbo ${BOOT_DIR}/overlays
