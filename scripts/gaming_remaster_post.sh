#!/bin/sh

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

# execute parent script
"${SABAYON_MOLECULE_HOME}"/scripts/remaster_post.sh "$@"

# Christmas TIME !
GAMING_XMAS_DIR="${SABAYON_MOLECULE_HOME}/remaster/gaming-xmas"
cp "${GAMING_XMAS_DIR}"/sabayonlinux.png "${CHROOT_DIR}/usr/share/backgrounds/sabayonlinux.png"
cp "${GAMING_XMAS_DIR}"/sabayonlinux.jpg "${CHROOT_DIR}/usr/share/backgrounds/sabayonlinux.jpg"
cp "${GAMING_XMAS_DIR}"/sabayonlinux.jpg "${CHROOT_DIR}/usr/share/backgrounds/kgdm.jpg"
