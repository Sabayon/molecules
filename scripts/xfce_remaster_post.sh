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
cp -rv "${GFORENSIC_DIR}"/etc "${CHROOT_DIR}/"
glib-compile-schemas "${CHROOT_DIR}/usr/share/glib-2.0/schemas/"
gsetttings set org.gnome.shell.extensions.dash-to-dock extended-height true
gsetttings set org.gnome.shell.extensions.dash-to-dock dock-position LEFT
gsetttings set org.gnome.shell.extensions.dash-to-dock transparency-mode DYNAMIC
gsetttings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsetttings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink true

echo "================================================"
echo "EXIT FROM XFCE-REMASTER-POST.SH"
echo "================================================"
