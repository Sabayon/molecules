#!/bin/sh

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

echo "================================================"
echo "ENTER ON XFCE-REMASTER-POST.SH"
echo "================================================"

GFORENSIC_DIR="${SABAYON_MOLECULE_HOME}/remaster/gforensic"

echo "================================================"
ls -l ${GFORENSIC_DIR}
echo "================================================"

# setup skel and background
cp -rv "${GFORENSIC_DIR}"/usr "${CHROOT_DIR}/"
sudo glib-compile-schemas "${CHROOT_DIR}/usr/share/glib-2.0/schemas/"

echo "================================================"
echo "EXIT FROM XFCE-REMASTER-POST.SH"
echo "================================================"
