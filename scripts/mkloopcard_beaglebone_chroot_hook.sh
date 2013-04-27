#!/bin/bash
# This script is executed inside the image chroot before packing up.
# Architecture/platform specific code goes here, like kernel install
# and configuration

env-update
. /etc/profile

sd_enable() {
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload -f enable "${1}.service"
}

sd_disable() {
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload -f disable "${1}.service"
}

setup_boot() {
	rc-update add sshd default
	sd_enable sshd

	rc-update add syslog-ng boot
	sd_enable syslog-ng

	rc-update add vixie-cron boot
	sd_enable vixie-cron

	rc-update add dbus boot
	rc-update add NetworkManager default
	rc-update add NetworkManager-setup default
	sd_enable NetworkManager

	# select the first available kernel
	eselect uimage set 1
	# cleaning up deps
	rc-update --update
}

setup_users() {
	# setup root password to... root!
	echo root:root | chpasswd
	# setup normal user "sabayon"
	(
		if [ ! -x "/sbin/sabayon-functions.sh" ]; then
			echo "no /sbin/sabayon-functions.sh found"
			exit 1
		fi
		. /sbin/sabayon-functions.sh
		sabayon_setup_live_user "sabayon" || exit 1
		# setup "sabayon" password to... sabayon!
		echo "sabayon:sabayon" | chpasswd
	)
}

setup_startup_caches() {
	mount -t proc proc /proc
	/lib/rc/bin/rc-depend -u
	# Generate openrc cache
	[[ -d "/lib/rc/init.d" ]] && touch /lib/rc/init.d/softlevel
	[[ -d "/run/openrc" ]] && touch /run/openrc/softlevel
	/etc/init.d/savecache start
	/etc/init.d/savecache zap
	ldconfig
	ldconfig
	umount /proc
}


setup_serial() {
	# Setup serial login
	sed -i "s:^s0.*::" /etc/inittab
	echo "s0:12345:respawn:/sbin/agetty 115200 ttyO0 vt100" >> /etc/inittab
}

setup_boot
setup_users
setup_serial
setup_startup_caches

exit 0

