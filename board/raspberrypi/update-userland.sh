#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Updates rpi-userland package version to the indicated commit hash or version."
    echo "Usage: $0 <version_or_commit>"
    exit 1
fi

version=$1
url=https://github.com/raspberrypi/userland/archive/${version}.tar.gz
base_dir=$(realpath $(dirname $0)/../..)
dl_dir=${base_dir}/dl
package_dir=${base_dir}/package/rpi-userland
archive_file=rpi-userland-${version}.tar.gz

echo "Downloading archive from ${url}"
curl -L "${url}" -o "${dl_dir}/${archive_file}"
checksum=$(sha256sum "${dl_dir}/${archive_file}" | cut -d ' ' -f 1)

echo "Updating rpi-userland package to ${version}"
sed -i "s/RPI_USERLAND_VERSION = .*/RPI_USERLAND_VERSION = ${version}/" "${package_dir}/rpi-userland.mk"
sed -ri "s/sha256(\s+)[a-f0-9]+(\s+)rpi-userland-.*/sha256\1${checksum}\2${archive_file}/" "${package_dir}/rpi-userland.hash"

echo "Committing changes"
cd ${base_dir}
git add package/rpi-userland
git commit -m "rpi-userland: Update to ${version}"

echo "Done!"
