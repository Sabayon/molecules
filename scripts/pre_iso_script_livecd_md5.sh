#!/bin/sh

LIVECD_SQUASHFS="${CDROOT_DIR}/livecd.squashfs"

if [ -f "${LIVECD_SQUASHFS}" ]; then
	echo
	echo "Generating md5 of ${LIVECD_SQUASHFS}..."
	echo
	(
		squash_dir=$(dirname "${LIVECD_SQUASHFS}")
		squash_name=$(basename "${LIVECD_SQUASHFS}")
		cd "${squash_dir}" && \
			md5sum "${squash_name}" > "${squash_name}.md5"
	)
fi
