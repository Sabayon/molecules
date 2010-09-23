#!/bin/sh
PKGS_DIR="/sabayon/pkgcache"
CHROOT_PKGS_DIR="${CHROOT_DIR}/var/lib/entropy/client/packages"

# make sure to not leak /proc
umount "${CHROOT_DIR}/proc" &> /dev/null
umount "${CHROOT_DIR}/proc" &> /dev/null
umount "${CHROOT_DIR}/proc" &> /dev/null

echo "Merging back packages"
cp "${CHROOT_PKGS_DIR}"/* "${PKGS_DIR}"/ -Ra
rm -rf "${CHROOT_PKGS_DIR}"{,-nonfree,-restricted}/*

exit 0
