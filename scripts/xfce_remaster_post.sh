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
cp "${GFORENSIC_DIR}"/files/org.freedesktop.udisks2.policy "${CHROOT_DIR}/usr/share/polkit-1/actions/org.freedesktop.udisks2.policy"
cp "${GFORENSIC_DIR}"/files/xorg.conf.kjs "${CHROOT_DIR}/etc/X11/xorg.conf.kjs"
cp "${GFORENSIC_DIR}"/files/xsettings.xml "${CHROOT_DIR}/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
cp "${GFORENSIC_DIR}"/files/xfce4-panel.xml "${CHROOT_DIR}/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
cp "${GFORENSIC_DIR}"/files/helpers.rc "${CHROOT_DIR}/etc/skel/.config/xfce4/helpers.rc"
cp "${GFORENSIC_DIR}"/files/rc.lua "${CHROOT_DIR}/etc/xdg/awesome/rc.lua"
cp "${GFORENSIC_DIR}"/files/theme.lua "${CHROOT_DIR}/etc/xdg/awesome/themes/default/theme.lua"
cp -r "${GFORENSIC_DIR}"/files/OSDark "${CHROOT_DIR}/usr/share/icons/"
cp -r "${GFORENSIC_DIR}"/files/NewSlickness-round "${CHROOT_DIR}/usr/share/themes/"
