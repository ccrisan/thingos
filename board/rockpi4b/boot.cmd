setenv load_addr "0x59000000"
setenv rootfstype "ext4"

echo "Boot script loaded from ${devtype} ${devnum}"

if test ${devnum} = 0; then
    setenv rootdev "/dev/mmcblk1p2"
    echo "Booting from eMMC"
else
    setenv rootdev "/dev/mmcblk0p2"
    echo "Booting from SD card"
fi

if test -e ${devtype} ${devnum} ${prefix}uEnv.txt; then
    load ${devtype} ${devnum} ${load_addr} ${prefix}uEnv.txt
    env import -t ${load_addr} ${filesize}
fi

setenv bootargs "root=${rootdev} rootfstype=${rootfstype} ${cmdline}"

echo "Boot args: ${bootargs}"
sysboot ${devtype} ${devnum} fat ${pxefile_addr_r} ${prefix}extlinux.conf
