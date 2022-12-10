#!/bin/bash

set -e

export TARGET="$1"
export BOARD=$(basename $(dirname ${TARGET}))
export COMMON_DIR=$(dirname $0)
export BOARD_DIR=${COMMON_DIR}/../${BOARD}
export BOOT_DIR=${TARGET}/../images/boot/

mkdir -p ${BOOT_DIR}

if [ -x ${BOARD_DIR}/postscript.sh ]; then
    ${BOARD_DIR}/postscript.sh
fi

# transform /var contents as needed
rm -rf ${TARGET}/var/cache
rm -rf ${TARGET}/var/lib
rm -rf ${TARGET}/var/lock
rm -rf ${TARGET}/var/log
rm -rf ${TARGET}/var/run
rm -rf ${TARGET}/var/spool
rm -rf ${TARGET}/var/tmp

ln -s /tmp ${TARGET}/var/cache
ln -s /tmp ${TARGET}/var/lock
ln -s /tmp ${TARGET}/var/run
ln -s /tmp ${TARGET}/var/spool
ln -s /tmp ${TARGET}/var/tmp
ln -s /tmp ${TARGET}/run
mkdir -p ${TARGET}/var/lib
mkdir -p ${TARGET}/var/log

# add admin user alias
if ! grep -qE '^admin:' ${TARGET}/etc/passwd; then
    echo "admin:x:0:0:root:/root:/bin/sh" >> ${TARGET}/etc/passwd
fi

# adjust root password
if [[ -n "${THINGOS_ROOT_PASSWORD_HASH}" ]] && [[ -f ${TARGET}/etc/shadow ]]; then
    echo "Updating root password hash"
    sed -ri "s,root:[^:]+:,root:${THINGOS_ROOT_PASSWORD_HASH}:," ${TARGET}/etc/shadow
    sed -ri "s,admin:[^:]+:,admin:${THINGOS_ROOT_PASSWORD_HASH}:," ${TARGET}/etc/shadow
fi
