#!/bin/sh
# This script is executed inside the image chroot before packing up.
# Architecture/platform specific code goes here, like kernel install
# and configuration

env-update
. /etc/profile

setup_displaymanager() {
	# determine what is the login manager
	if [ -n "$(equo match --installed gnome-base/gdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="gdm"/g' /etc/conf.d/xdm
	elif [ -n "$(equo match --installed lxde-base/lxdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="lxdm"/g' /etc/conf.d/xdm
	elif [ -n "$(equo match --installed kde-base/kdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="kdm"/g' /etc/conf.d/xdm
	else
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="xdm"/g' /etc/conf.d/xdm
	fi
}

setup_desktop_environment() {
	if [ -f "/usr/share/xsessions/LXDE.desktop" ]; then
		echo "[Desktop]" > /etc/skel/.dmrc
		echo "Session=LXDE" >> /etc/skel/.dmrc
	elif [ -n "/usr/share/xsessions/xfce.desktop" ]; then
		echo "[Desktop]" > /etc/skel/.dmrc
		echo "Session=xfce" >> /etc/skel/.dmrc

	else
		# Fluxbox is always there
		echo "[Desktop]" > /etc/skel/.dmrc
		echo "Session=fluxbox" >> /etc/skel/.dmrc
	fi
}

setup_boot() {
	# enable sshd by default
	rc-update add sshd default
	# enable logger by default
	rc-update add syslog-ng boot
	rc-update add vixie-cron boot
	# enable dbus, of course, and also NetworkManager
	rc-update add dbus boot
	rc-update add NetworkManager default
	rc-update add NetworkManager-setup default
	rc-update del net.eth0 default

	# start X.Org by default
	rc-update add xdm default

	# select the first available kernel
	eselect uimage set 1

	# cleaning up deps
	rc-update --update
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

		# also add "sabayon" to disk group
		usermod -a -G disk sabayon
	)
}

setup_serial() {
	# setup serial login
	sed -i "s:^s0.*::" /etc/inittab
	echo "s0:12345:respawn:/sbin/agetty 115200 ttyO2 vt100" >> /etc/inittab
}

setup_displaymanager
setup_desktop_environment
setup_users
setup_boot
setup_serial
setup_startup_caches

exit 0

