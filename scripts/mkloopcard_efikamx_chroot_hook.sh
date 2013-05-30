#!/bin/bash
# This script is executed inside the image chroot before packing up.
# Architecture/platform specific code goes here, like kernel install
# and configuration

/usr/sbin/env-update
. /etc/profile

. /mkloopcard_chroot.include || exit 1

setup_fstab() {
    # add /dev/mmcblk0p1 to /etc/fstab
    local boot_part_type="${BOOT_PART_TYPE:-ext3}"
    echo "/dev/mmcblk0p1  /boot  ${boot_part_type}  defaults  0 1" >> /etc/fstab
}

setup_displaymanager
setup_desktop_environment
setup_users
setup_boot
setup_fstab

# We need OpenRC due to the old kernel
eselect init set sysvinit
eselect settingsd set openrc

exit 0
