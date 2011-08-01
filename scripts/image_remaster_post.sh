#!/bin/sh

# execute parent script
/sabayon/scripts/remaster_post.sh
if [ "${?}" != "0" ]; then
	exit 1
fi

# Setup provisioning script for Amazon EC2 to load at startup
EC2_DIR="/sabayon/remaster/ec2_image"
PROV_SCRIPT="ec2.start"
cp -p "${EC2_DIR}/${PROV_SCRIPT}" "${CHROOT_DIR}/etc/local.d/"  || exit 1
chown root:root "${CHROOT_DIR}/etc/local.d/${PROV_SCRIPT}" || exit 1
chmod 744 "${CHROOT_DIR}/etc/local.d/${PROV_SCRIPT}" || exit 1

exit 0
