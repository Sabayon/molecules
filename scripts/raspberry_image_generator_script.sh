#!/bin/sh

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

# sigh vfat
export BOOT_PART_TYPE_INSIDE_ROOT="1"

exec "${SABAYON_MOLECULE_HOME}"/scripts/mkloopcard.sh "${SABAYON_MOLECULE_HOME}"/scripts/mkloopcard_raspberry_chroot_hook.sh "${@}"
