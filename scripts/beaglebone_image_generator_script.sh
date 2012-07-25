#!/bin/sh

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

exec "${SABAYON_MOLECULE_HOME}"/scripts/mkloopcard.sh "${SABAYON_MOLECULE_HOME}"/scripts/mkloopcard_beaglebone_chroot_hook.sh "$@"
