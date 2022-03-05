setenv load_addr "0x59000000"
setenv rootdev "/dev/mmcblk0p2"
setenv rootfstype "ext4"

echo "Boot script loaded from ${devtype} ${devnum}"

if test -e ${devtype} ${devnum} ${prefix}uEnv.txt; then
    load ${devtype} ${devnum} ${load_addr} ${prefix}uEnv.txt
    env import -t ${load_addr} ${filesize}
fi

setenv bootargs "root=${rootdev} rootfstype=${rootfstype} ${cmdline}"
if test -n "${initrd}"; then
    setenv bootargs "${bootargs} initrd=${initrd}"
    load ${devtype} ${devnum} ${ramdisk_addr_r} ${prefix}${initrd}
    setenv initrd_size ${filesize}
fi

load ${devtype} ${devnum} ${kernel_addr_r} ${prefix}${kernel}
load ${devtype} ${devnum} ${fdt_addr_r} ${prefix}${fdt}
fdt addr ${fdt_addr_r}
fdt resize 65536
for overlay_file in ${overlays}; do
    if load ${devtype} ${devnum} ${load_addr} ${prefix}overlays/${overlay_file}.dtbo; then
        echo "Applying kernel provided DT overlay ${overlay_file}.dtbo"
        fdt apply ${load_addr}
    fi
done

booti ${kernel_addr_r} ${ramdisk_addr_r}:${initrd_size} ${fdt_addr_r}
