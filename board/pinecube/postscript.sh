#!/bin/sh

cp ${BINARIES_DIR}/zImage ${BOOT_DIR}
cp ${BINARIES_DIR}/sun8i-s3-pinecube.dtb ${BOOT_DIR}
cp ${BINARIES_DIR}/boot.scr ${BOOT_DIR}

cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${BOARD_DIR}/uEnv.txt ${BOOT_DIR}
