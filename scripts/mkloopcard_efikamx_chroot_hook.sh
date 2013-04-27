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

setup_displaymanager() {
	# determine what is the login manager
	if [ -n "$(equo match --installed gnome-base/gdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="gdm"/g' /etc/conf.d/xdm
		sd_enable gdm
	elif [ -n "$(equo match --installed lxde-base/lxdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="lxdm"/g' /etc/conf.d/xdm
		sd_enable lxdm
	elif [ -n "$(equo match --installed kde-base/kdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="kdm"/g' /etc/conf.d/xdm
		sd_enable kdm
	else
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="xdm"/g' /etc/conf.d/xdm
		sd_enable xdm
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

	rc-update del net.eth0 default
	rc-update add xdm default

	eselect uimage set 1
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
	echo "s0:12345:respawn:/sbin/agetty 115200 ttymxc0 vt100" >> /etc/inittab
	echo "ttymxc0" >> /etc/securetty
}

setup_fstab() {
	# add /dev/mmcblk0p1 to /etc/fstab
	local boot_part_type="${BOOT_PART_TYPE:-ext3}"
	echo "/dev/mmcblk0p1  /boot  ${boot_part_type}  noauto  0 1" >> /etc/fstab
}

setup_displaymanager
setup_desktop_environment
setup_users
setup_boot
setup_serial
setup_fstab
setup_startup_caches

exit 0

