#!/bin/bash
# Update ISO image in order to make it USB bootable
# out of the box
#
# Available env vars:
# ISO_PATH = path to generated ISO
# ISO_CHECKSUM_PATH = path to generated md5 for ISO
#
# This script requires isohybrid (which comes from syslinux package)

/usr/sbin/env-update
. /etc/profile

ISO_ARCH="${1}"
shift

echo
echo "Spawning isohybrid for:"
echo "ISO_PATH = ${ISO_PATH}"
echo "ISO_CHECKSUM_PATH = ${ISO_CHECKSUM_PATH}"
echo "ISO_ARCH = ${ISO_ARCH}"
echo

ih_args=""
if [ "${ISO_ARCH}" = "amd64" ]; then
	ih_args+=" --uefi"
fi
isohybrid ${ih_args} "${ISO_PATH}" || exit 1

# FIXME: With certain versions of udev/blkid on specific hosts, resolving
# the rootfs livecd by label fails to the wrong partition (e.g. efi), preventing to boot.
# Meanwhile workaround it by writing an hardcoded udf UUID, but this could be
# also automatically generated to have also predictable builds.
# Requires sys-fs/udftools
udflabel --force -u 5c403dad00049b51 "${ISO_PATH}" SABAYON || exit 1

cd "$(dirname "${ISO_PATH}")" || exit 1
iso_name=$(basename "${ISO_PATH}")
md5sum "${iso_name}" > "${ISO_CHECKSUM_PATH}"

exit ${?}
