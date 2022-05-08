setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootwait rw

fatload mmc 0 ${loadaddr} uEnv.txt
env import -t ${loadaddr} ${filesize}

if test -n "${initrd}"; then
    setenv bootargs "${bootargs} initrd=${initrd}"
    fatload mmc 0 ${ramdisk_addr_r} ${initrd}
    setenv initrd_size ${filesize}
fi

fatload mmc 0 ${kernel_addr_r} ${kernel}
fatload mmc 0 ${fdt_addr_r} ${fdt}

echo "Boot args: ${bootargs}"
if test -n "${initrd}"; then
    echo "Initrd size is ${initrd_size}"
    bootz ${kernel_addr_r} ${ramdisk_addr_r}:${initrd_size} ${fdt_addr_r}
else
    bootz ${kernel_addr_r} - ${fdt_addr_r}
fi
