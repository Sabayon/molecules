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
cp -v "${GFORENSIC_DIR}"/usr/share/backgrounds/sabayon-forensic.png "${CHROOT_DIR}/usr/share/backgrounds/"
cp -v "${GFORENSIC_DIR}"/usr/share/backgrounds/sabayon-forensic.jpg "${CHROOT_DIR}/usr/share/backgrounds/"
cp -v "${GFORENSIC_DIR}"/usr/share/backgrounds/kgdm.jpg "${CHROOT_DIR}/usr/share/backgrounds/kgdm.jpg"
cp -v "${GFORENSIC_DIR}"/files/org.freedesktop.udisks.policy "${CHROOT_DIR}/usr/share/polkit-1/actions/org.freedesktop.udisks.policy"
cp -v "${GFORENSIC_DIR}"/files/org.freedesktop.udisks2.policy "${CHROOT_DIR}/usr/share/polkit-1/actions/org.freedesktop.udisks2.policy"
cp -v "${GFORENSIC_DIR}"/files/theme.lua "${CHROOT_DIR}/etc/xdg/awesome/themes/default/theme.lua"
cp -rv "${GFORENSIC_DIR}"/files/Qogir-dark "${CHROOT_DIR}/usr/share/themes/"
cp -v "${GFORENSIC_DIR}"/files/forensic-desktops/* "${CHROOT_DIR}/usr/share/applications/"
cp -v "${GFORENSIC_DIR}"/files/org.sabayon.gschema.override "${CHROOT_DIR}/usr/share/glib-2.0/schemas/org.sabayon.gschema.override"
cp -v "${GFORENSIC_DIR}"/files/org.gnome.shell.extensions.dash-to-dock.gschema.xml "${CHROOT_DIR}/usr/share/glib-2.0/schemas/org.gnome.shell.extensions.dash-to-dock.gschema.xml"

echo "================================================"
echo "EXIT FROM XFCE-REMASTER-POST.SH"
echo "================================================"
