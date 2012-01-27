#!/bin/sh
# This script is executed inside the image chroot before packing up.
# Architecture/platform specific code goes here, like kernel install
# and configuration

env-update
. /etc/profile

# enable sshd by default
rc-update add sshd default

# TODO: error out here when linux-beaglebone is there
# "equo update" is done by inner_source_chroot_update script
# which directive is appended by iso_build.sh script
equo install sys-kernel/linux-beagle

eselect uimage set 1

# setup root password to... root!
echo root:root | chpasswd
# cleaning up deps
rc-update --update

# setup serial console
sed -i "s;s0:.*;s0:12345:respawn:/sbin/agetty 115200 ttyO2 vt100;" /etc/inittab || exit 1

exit 0

