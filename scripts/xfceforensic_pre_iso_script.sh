#!/bin/bash

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

# Call parent script, generates ISOLINUX and other stuff
"${SABAYON_MOLECULE_HOME}"/scripts/generic_pre_iso_script.sh "Forensic"

GFORENSIC_DIR="${SABAYON_MOLECULE_HOME}/remaster/gforensic"
cp "${GFORENSIC_DIR}"/isolinux/back.jpg "${CDROOT_DIR}/isolinux/back.jpg"
cp "${GFORENSIC_DIR}"/boot/grub/default-splash.png "${CDROOT_DIR}/boot/grub/default-splash.png"
