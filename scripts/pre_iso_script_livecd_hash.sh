#!/bin/sh

LIVECD_SQUASHFS="${CDROOT_DIR}/livecd.squashfs"

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

echo
echo "Generating sha256sums..."
echo

# create sha256 file for livecd.squashfs
if [ -f "${LIVECD_SQUASHFS}" ]; then
	echo "Doing ${LIVECD_SQUASHFS}..."
	squash_dir=$(dirname "${LIVECD_SQUASHFS}")
	squash_name=$(basename "${LIVECD_SQUASHFS}")
	pushd "${squash_dir}" > /dev/null && \
		sha256sum "${squash_name}" > "${squash_name}.sha256" && \
		popd > /dev/null
fi

# files inside /boot now
if [ -d "${CDROOT_DIR}/boot" ]; then
	# delete existing .sha256 files
	find "${CDROOT_DIR}/boot" -name "*.sha256" -delete
	for bootfile in "${CDROOT_DIR}"/boot/* ; do
		if [ -f "${bootfile}" ]; then
			echo "Doing ${bootfile}..."
			boot_dir=$(dirname "${bootfile}")
			boot_name=$(basename "${bootfile}")
			pushd "${boot_dir}" > /dev/null && \
				sha256sum "${boot_name}" > "${boot_name}.sha256" && \
				popd > /dev/null
		fi
	done
fi

# move cdupdate.sh in place
cp "${SABAYON_MOLECULE_HOME}/scripts/cdupdate.sh" "${CDROOT_DIR}/cdupdate.sh" && \
	chmod +x "${CDROOT_DIR}/cdupdate.sh" && \
	chown root:root "${CDROOT_DIR}/cdupdate.sh"
