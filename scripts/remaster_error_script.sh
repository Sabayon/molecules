#!/bin/sh
if [ -d "${CHROOT_DIR}" ]; then
	umount "${CHROOT_DIR}/proc"
fi

echo "Umounting bind to ${CHROOT_PKGS_DIR}"
umount "${CHROOT_PKGS_DIR}" || exit 1
