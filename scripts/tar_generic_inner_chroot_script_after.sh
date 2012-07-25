#!/bin/sh

/usr/sbin/env-update
. /etc/profile

# remove sabayonuser
userdel sabayonuser

DROP_SERVICES="
	alsasound
	avahi-daemon
	consolefont
	dbus
	fbcondecor
	fsck
	hotplug
	hwclock
	installer-gui
	installer-text
	keymaps
	lvm
	mdadm
	netmount
	NetworkManager
	sabayonlive
	swap
	swapfiles
	termencoding
	x-setup
"

for serv in ${DROP_SERVICES}; do
	rc-update del ${serv} default
	rc-update del ${serv} boot
done
rc-update add vixie-cron default
rc-update del udev sysinit
rc-update del dmesg sysinit

# Generate list of installed packages
equo query list installed -qv > /etc/sabayon-pkglist

# remove hw hash
rm -f /etc/entropy/.hw.hash
# remove entropy pid file
rm -f /var/run/entropy/entropy.lock

exit 0
