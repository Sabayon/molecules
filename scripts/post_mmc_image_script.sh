#!/bin/bash
# Compress the freaking MMC image using xz
#
# Available env vars:
# IMAGE_PATH = path to generated image
# IMAGE_CHECKSUM_PATH = path to generated md5 for image
#

/usr/sbin/env-update
. /etc/profile

COMPRESSED_IMAGE_PATH="${IMAGE_PATH}.xz"
COMPRESSED_IMAGE_CHECKSUM_PATH="${COMPRESSED_IMAGE_PATH}.md5"

echo
echo "Spawning xz --compress --force for:"
echo "IMAGE_PATH = ${IMAGE_PATH}"
echo "COMPRESSED_IMAGE_PATH = ${COMPRESSED_IMAGE_PATH}"
echo "COMPRESSED_IMAGE_CHECKSUM_PATH = ${COMPRESSED_IMAGE_CHECKSUM_PATH}"
echo

xz --compress --force "${IMAGE_PATH}" || exit 1
[[ ! -f "${COMPRESSED_IMAGE_PATH}" ]] && { echo "${COMPRESSED_IMAGE_PATH} not found"; exit 1; }

chmod 644 "${COMPRESSED_IMAGE_PATH}" || exit 1

cd "$(dirname "${COMPRESSED_IMAGE_PATH}")" || exit 1
img_name=$(basename "${COMPRESSED_IMAGE_PATH}")
# make sure to not leave zombies
rm -f "${img_name}.md5"
md5sum "${img_name}" > "${COMPRESSED_IMAGE_CHECKSUM_PATH}" || exit 1

echo "All done"

exit ${?}

