#!/bin/sh

mkdir -p ${BOOT_DIR}/overlays

cp ${BOARD_DIR}/config.txt ${BOOT_DIR}
cp ${BOARD_DIR}/cmdline.txt ${BOOT_DIR}
cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${BINARIES_DIR}/zImage ${BOOT_DIR}
cp ${BINARIES_DIR}/*.dtb ${BOOT_DIR}
cp ${BINARIES_DIR}/rpi-firmware/bootcode.bin ${BOOT_DIR}
cp ${BINARIES_DIR}/rpi-firmware/start*.elf ${BOOT_DIR}
cp ${BINARIES_DIR}/rpi-firmware/fixup*.dat ${BOOT_DIR}
cp ${BINARIES_DIR}/rpi-firmware/overlays/*.dtbo ${BOOT_DIR}/overlays
