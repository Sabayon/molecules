#!/bin/sh

# execute parent script
/sabayon/scripts/remaster_post.sh $@

# Christmas TIME !
GAMING_XMAS_DIR="/sabayon/remaster/gaming-xmas"
cp "${GAMING_XMAS_DIR}"/sabayonlinux.png "${CHROOT_DIR}/usr/share/backgrounds/sabayonlinux.png"
cp "${GAMING_XMAS_DIR}"/sabayonlinux.jpg "${CHROOT_DIR}/usr/share/backgrounds/sabayonlinux.jpg"
cp "${GAMING_XMAS_DIR}"/sabayonlinux.jpg "${CHROOT_DIR}/usr/share/backgrounds/kgdm.jpg"
