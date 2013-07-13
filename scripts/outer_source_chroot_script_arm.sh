#!/bin/bash

/usr/sbin/env-update
. /etc/profile

# Execute this here due to technical problems with qemu-user

# Update /usr/portage/profiles
# This is actually not strictly needed but several
# gentoo tools expect to find valid /etc/make.profile symlink
# This part is best effort, if it will be able to complete
# correctly, fine.
# For a list of mirrors, see: http://www.gentoo.org/main/en/mirrors-rsync.xml
RSYNC_URI="rsync://rsync.at.gentoo.org/gentoo-portage/profiles"
PROFILES_DIR="${CHROOT_DIR}/usr/portage/profiles"
for x in $(seq 5); do
	rsync -av -H -A -X --delete-during "${RSYNC_URI}/" "${PROFILES_DIR}/" && break
	sleep 1m || exit 1
done

exit 0
