#!/bin/sh

# Copy packages list outside tarball
pkglist_file="${CHROOT_DIR}/etc/sabayon-pkglist"
if [ -f "${pkglist_file}" ]; then
	tar_dirname=$(dirname "${TAR_PATH}")
	if [ -d "${tar_dirname}" ]; then
		cp "${pkglist_file}" "${TAR_PATH}.pkglist"
	fi
fi
