#!/bin/sh

export BOOT_PART_MKFS_ARGS="-L boot"
export BOOT_PART_TYPE=ext3
export BOOT_PART_TYPE_MBR=83
export BOOT_PART_TYPE_INSIDE_ROOT=1
export ROOT_PART_TYPE=ext4
export MAKE_TARBALL=0

exec /sabayon/scripts/mkloopcard.sh /sabayon/scripts/mkloopcard_efikamx_chroot_hook.sh "$@"
