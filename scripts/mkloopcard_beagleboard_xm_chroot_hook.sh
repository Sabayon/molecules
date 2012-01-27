#!/bin/sh
# This script is executed inside the image chroot before packing up.
# Architecture/platform specific code goes here, like kernel install
# and configuration

env-update
. /etc/profile

# enable sshd by default
rc-update add sshd default

# select the first available kernel
eselect uimage set 1

# setup root password to... root!
echo root:root | chpasswd
# cleaning up deps
rc-update --update

# setup serial login
echo "s0:12345:respawn:/sbin/agetty 115200 ttyO2 vt100" >> /etc/inittab

exit 0

