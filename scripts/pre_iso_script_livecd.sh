#!/bin/sh

LIVECD_SQUASHFS="${CDROOT_DIR}/livecd.squashfs"

if [ -n "${DRACUT}" ] && [ -f "${LIVECD_SQUASHFS}" ]; then
  squash_dir=$(TMPDIR="/var/tmp" mktemp -d --suffix="dracut")
  mkdir -p "${squash_dir}/LiveOS"
  mkdir -p "${CDROOT_DIR}/LiveOS"
  mv "${LIVECD_SQUASHFS}" "${squash_dir}/LiveOS/rootfs.img"
  LIVECD_SQUASHFS="${CDROOT_DIR}/LiveOS/squashfs.img"
  echo "Rebuilding ${LIVECD_SQUASHFS}..."
  mksquashfs "${squash_dir}" "${LIVECD_SQUASHFS}"
  rm -rf "${squash_dir}"
fi

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME
export LIVECD_SQUASHFS
