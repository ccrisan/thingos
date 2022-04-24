#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Updates rpi-firmware package to the indicated commit hash or version."
    echo "Then updates the Linux kernel version for all Raspberry PI boards accordingly."
    echo "Usage: $0 <version_or_commit>"
    exit 1
fi

# Supported Raspberry Pi platforms
BOARDS="raspberrypi raspberrypi2 raspberrypi3 raspberrypi4 raspberrypi64"

version=$1
url=https://github.com/raspberrypi/firmware/archive/${version}.tar.gz
base_dir=$(realpath $(dirname $0)/../..)
dl_dir=${base_dir}/dl
package_dir=${base_dir}/package/rpi-firmware
archive_file=rpi-firmware-${version}.tar.gz

echo "Downloading archive from ${url}"
curl -L "${url}" -o "${dl_dir}/${archive_file}"
checksum=$(sha256sum "${dl_dir}/${archive_file}" | cut -d ' ' -f 1)

echo "Updating rpi-firmware package to ${version}"
sed -i "s/RPI_FIRMWARE_VERSION = .*/RPI_FIRMWARE_VERSION = ${version}/" "${package_dir}/rpi-firmware.mk"
sed -ri "s/sha256(\s+)[a-f0-9]+(\s+)rpi-firmware-.*/sha256\1${checksum}\2${archive_file}/" "${package_dir}/rpi-firmware.hash"

tmp_dir=$(mktemp -d)
echo "Extracting ${archive_file}"
tar xf "${dl_dir}/${archive_file}" -C "${tmp_dir}"
kernel_version=$(cat "${tmp_dir}/firmware-${version}/extra/git_hash")
rm -rf "${tmp_dir}"

conf=BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION
base_url=https://github.com/raspberrypi/linux/archive/
ext=.tar.gz
for board in ${BOARDS}; do
    echo "Updating Linux kernel version to ${kernel_version} for ${board}"
    sed -ri "s,${conf}=\"${base_url}[a-f0-9]+${ext}\",${conf}=\"${base_url}${kernel_version}${ext}\"," \
        "${base_dir}/configs/${board}_defconfig"
done

echo "Committing changes"
cd ${base_dir}
git add package/rpi-firmware
git commit -m "rpi-firmware: Update to ${version}"
git add configs
git commit -m "raspberrypi(all): Update kernel to ${kernel_version}"

echo "Done!"
