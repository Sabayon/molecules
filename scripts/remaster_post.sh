#!/bin/sh
PKGS_DIR="/sabayon/pkgcache"
CHROOT_PKGS_DIR="${CHROOT_DIR}/var/lib/entropy/client/packages"

echo "Merging back packages"
cp "${CHROOT_PKGS_DIR}"/* "${PKGS_DIR}"/ -Ra
rm -rf "${CHROOT_PKGS_DIR}"{,-nonfree,-restricted}/*
