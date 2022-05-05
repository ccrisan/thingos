setenv load_addr "0x44000000"
setenv rootfstype "ext4"
setenv devnum 0

if mmc dev 1; then
    setenv rootdev "/dev/mmcblk1p2"
    echo "Booting from SD card"
else
    setenv rootdev "/dev/mmcblk3p2"
    echo "Booting from eMMC"
fi

load mmc ${devnum} ${load_addr} uEnv.txt
env import -t ${load_addr} ${filesize}

setenv bootargs "root=${rootdev} rootfstype=${rootfstype} ${cmdline}"
if test -n "${initrd}"; then
    setenv bootargs "${bootargs} initrd=${initrd}"
    load mmc ${devnum} ${ramdisk_addr_r} ${initrd}
    setenv initrd_size ${filesize}
fi

load mmc ${devnum} ${kernel_addr_r} ${kernel}
load mmc ${devnum} ${fdt_addr_r} ${fdt}
fdt addr ${fdt_addr_r}
fdt resize 65536
for overlay_file in ${overlays}; do
    if load mmc ${devnum} ${load_addr} overlays/${overlay_file}.dtbo; then
        echo "Applying kernel provided DT overlay ${overlay_file}.dtbo"
        fdt apply ${load_addr}
    fi
done

echo "Boot args: ${bootargs}"
if test -n "${initrd}"; then
    echo "Initrd size is ${initrd_size}"
    bootz ${kernel_addr_r} ${ramdisk_addr_r}:${initrd_size} ${fdt_addr_r}
else
    bootz ${kernel_addr_r} - ${fdt_addr_r}
fi
