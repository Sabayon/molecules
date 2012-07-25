#!/bin/sh

export BOOT_PART_MKFS_ARGS="-L boot"
export BOOT_PART_TYPE=ext3
export BOOT_PART_TYPE_MBR=83
export BOOT_PART_TYPE_INSIDE_ROOT=1
export ROOT_PART_TYPE=ext4
export MAKE_TARBALL=0

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

exec "${SABAYON_MOLECULE_HOME}"/scripts/mkloopcard.sh "${SABAYON_MOLECULE_HOME}"/scripts/mkloopcard_efikamx_chroot_hook.sh "$@"
