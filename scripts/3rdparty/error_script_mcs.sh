#!/bin/sh
if [ -d "${CHROOT_DIR}" ]; then
	umount "${CHROOT_DIR}/proc"
fi
