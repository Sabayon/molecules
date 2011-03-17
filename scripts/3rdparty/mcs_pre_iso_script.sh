#!/bin/sh

# setup ISOLINUX background
cp /sabayon/remaster/mcs/isolinux/back.jpg "${CDROOT_DIR}/isolinux/back.jpg" || exit 1

# execute parent script
/sabayon/scripts/generic_pre_iso_script.sh MCS || exit 1

echo "Copying new kernel images over"
boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
cp "${boot_kernel}" "${CDROOT_DIR}/boot/sabayon" || exit 1
cp "${boot_ramfs}" "${CDROOT_DIR}/boot/sabayon.igz" || exit 1

# Setup default splash theme
sed -i "s/theme:sabayon/theme:babel/g" "${CDROOT_DIR}/isolinux/txt.cfg" || exit 1
