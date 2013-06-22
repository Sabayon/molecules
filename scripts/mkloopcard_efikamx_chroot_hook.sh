#!/bin/bash
# This script is executed inside the image chroot before packing up.
# Architecture/platform specific code goes here, like kernel install
# and configuration

/usr/sbin/env-update
. /etc/profile

. /mkloopcard_chroot.include || exit 1

setup_displaymanager
setup_desktop_environment
setup_users
setup_boot
setup_bootfs_fstab "ext3"

# We need OpenRC due to the old kernel
eselect init set sysvinit

exit 0
