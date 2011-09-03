#!/bin/sh

# execute parent script
/sabayon/scripts/remaster_post.sh

GFORENSIC_DIR="/sabayon/remaster/gforensic"
# setup skel and background
cp "${GFORENSIC_DIR}"/usr/share/backgrounds/sabayon-forensic.png "${CHROOT_DIR}/usr/share/backgrounds/sabayonlinux.png"
cp "${GFORENSIC_DIR}"/usr/share/backgrounds/sabayon-forensic.jpg "${CHROOT_DIR}/usr/share/backgrounds/sabayonlinux.jpg"
cp "${GFORENSIC_DIR}"/usr/share/backgrounds/sabayon-forensic.jpg "${CHROOT_DIR}/usr/share/themes/Adwaita/backgrounds/stripes.jpg"
cp "${GFORENSIC_DIR}"/usr/share/backgrounds/kgdm.jpg ${CHROOT_DIR}/usr/share/backgrounds/kgdm.jpg
cp "${GFORENSIC_DIR}"/files/org.freedesktop.udisks.policy "${CHROOT_DIR}/usr/share/polkit-1/actions/org.freedesktop.udisks.policy"
cp "${GFORENSIC_DIR}"/files/xorg.conf.kjs "${CHROOT_DIR}/etc/X11/xorg.conf.kjs"
cp "${GFORENSIC_DIR}"/etc/skel/.gconf/desktop/gnome/interface/%gconf.xml "${CHROOT_DIR}/etc/skel/.gconf/desktop/gnome/interface/%gconf.xml"
cp "${GFORENSIC_DIR}"/etc/skel/.gconf/apps/nautilus/preferences/%gconf.xml "${CHROOT_DIR}/etc/skel/.gconf/apps/nautilus/preferences/%gconf.xml"
