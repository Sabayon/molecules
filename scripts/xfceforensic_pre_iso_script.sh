#!/bin/bash

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

GFORENSIC_DIR="${SABAYON_MOLECULE_HOME}/remaster/gforensic"
cp "${GFORENSIC_DIR}"/isolinux/isolinux.cfg "${CDROOT_DIR}/isolinux/txt.cfg"
cp "${GFORENSIC_DIR}"/isolinux/back.jpg "${CDROOT_DIR}/isolinux/back.jpg"
cp "${GFORENSIC_DIR}"/isolinux/isolinux.txt "${CDROOT_DIR}/isolinux/isolinux.txt"
