#!/bin/bash

/usr/sbin/env-update
. /etc/profile

. /mkloopcard_chroot.include || exit 1

setup_displaymanager
setup_desktop_environment
setup_users
setup_boot
setup_bootfs_fstab "vfat"

exit 0
