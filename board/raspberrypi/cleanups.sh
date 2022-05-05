#!/bin/bash

TARGET=$1
test -n "${TARGET}" || exit 1

rm -rf ${TARGET}/opt/vc/src
rm -rf ${TARGET}/opt/vc/include
rm -rf ${TARGET}/usr/bin/dtoverlay-*
