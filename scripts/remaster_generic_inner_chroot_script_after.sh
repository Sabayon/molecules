#!/bin/bash

/usr/sbin/env-update
. /etc/profile

basic_environment_setup() {
	eselect opengl set xorg-x11 &> /dev/null

	# automatically start xdm
	rc-update del xdm default
	rc-update del xdm boot
	rc-update add xdm boot

	# consolekit must be run at boot level
	rc-update add consolekit boot

	# if it exists
	if [ -f "/etc/init.d/hald" ]; then
		rc-update del hald boot
		rc-update del hald
		rc-update add hald boot
	fi

	rc-update del music boot
	rc-update add music default
	rc-update del sabayon-mce default
	rc-update add nfsmount default

	if [ -f /etc/init.d/zfs ] && [ "$(uname -m)" = "x86_64" ]; then
		rc-update add zfs boot
	fi

	# Always startup this
	rc-update add virtualbox-guest-additions boot

	# Create a default "games" group so that
	# the default user will be added to it during
	# live boot, and thus, after install.
	# See bug 3134
	groupadd -f games
}

remove_desktop_files() {
	rm /etc/skel/Desktop/WorldOfGooDemo-world-of-goo-demo.desktop
}

setup_cpufrequtils() {
	rc-update add cpufrequtils default
}

setup_sabayon_mce() {
	rc-update add sabayon-mce boot
	# not needed, done by app-misc/sabayon-mce pkg
	# Sabayon Media Center user setup
	# source /sbin/sabayon-functions.sh
	# sabayon_setup_live_user "sabayonmce"
}

switch_kernel() {
	local from_kernel="${1}"
	local to_kernel="${2}"

	kernel-switcher switch "${to_kernel}"
	if [ "${?}" != "0" ]; then
		return 1
	fi
	equo remove "${from_kernel}"
	if [ "${?}" != "0" ]; then
		return 1
	fi
	return 0
}

setup_displaymanager() {
	# determine what is the login manager
	if [ -n "$(equo match --installed gnome-base/gdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="gdm"/g' /etc/conf.d/xdm
	elif [ -n "$(equo match --installed lxde-base/lxdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="lxdm"/g' /etc/conf.d/xdm
        elif [ -n "$(equo match --installed x11-misc/lightdm -qv)" ]; then
                sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="lightdm"/g' /etc/conf.d/xdm
	elif [ -n "$(equo match --installed kde-base/kdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="kdm"/g' /etc/conf.d/xdm
	else
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="xdm"/g' /etc/conf.d/xdm
	fi
}

setup_networkmanager() {
	rc-update del NetworkManager default
	rc-update del NetworkManager
	rc-update add NetworkManager default
	rc-update add NetworkManager-setup default
}

xfceforensic_remove_skel_stuff() {
	# remove no longer needed folders/files
	rm -rf /etc/skel/.config/xfce4/desktop
	rm -rf /etc/skel/.config/xfce4/panel
	rm -rf /etc/skel/Desktop/*
	rm -rf /usr/share/backgrounds/iottinka
	rm -rf /usr/share/wallpapers/*
}

remove_mozilla_skel_cruft() {
	rm -rf /etc/skel/.mozilla
}

setup_oss_gfx_drivers() {
	# do not tweak eselect mesa, keep defaults

	# This file is polled by the txt.cfg
	# (isolinux config file) setup script
	touch /.enable_kms

	# Remove nouveau from blacklist
	sed -i ":^blacklist: s:blacklist nouveau:# blacklist nouveau:g" \
		/etc/modprobe.d/blacklist.conf
}

has_proprietary_drivers() {
	local is_nvidia=$(equo match --installed x11-drivers/nvidia-drivers -qv)
	if [ -n "${is_nvidia}" ]; then
		return 0
	fi
	local is_ati=$(equo match --installed x11-drivers/ati-drivers -qv)
	if [ -n "${is_ati}" ]; then
		return 0
	fi
	return 1
}

setup_proprietary_gfx_drivers() {
	# Prepare NVIDIA legacy drivers infrastructure

	if [ ! -d "/install-data/drivers" ]; then
		mkdir -p /install-data/drivers
	fi
	myuname=$(uname -m)
	mydir="x86"
	if [ "$myuname" == "x86_64" ]; then
		mydir="amd64"
	fi
	kernel_ver="$(equo match --installed -qv virtual/linux-binary | cut -d/ -f 2)"
	# strip -r** if exists, hopefully we don't have PN ending with -r
	kernel_ver="${kernel_ver%-r*}"
	kernel_tag_file="/etc/kernels/${kernel_ver}/RELEASE_LEVEL"
	if [ ! -f "${kernel_tag_file}" ]; then
		echo "cannot find ${kernel_tag_file}, wtf" >&2
		# do not return 1 !!!
		return 0
	fi
	kernel_tag="#$(cat "${kernel_tag_file}")"

	rm -rf /var/lib/entropy/client/packages/packages*/${mydir}/*/x11-drivers*
	# TODO: move to equo match x11-drivers/nvidia-drivers$kernel_tag --quiet --verbose --injected --multimatch
	# but also the latest kernel is marked as injected, so you need to sort and filter out
	ACCEPT_LICENSE="NVIDIA" equo install --fetch --nodeps =x11-drivers/nvidia-userspace-304*$kernel_tag \
		=x11-drivers/nvidia-drivers-304*$kernel_tag
	ACCEPT_LICENSE="NVIDIA" equo install --fetch --nodeps =x11-drivers/nvidia-userspace-173*$kernel_tag \
		=x11-drivers/nvidia-drivers-173*$kernel_tag
	ACCEPT_LICENSE="NVIDIA" equo install --fetch --nodeps =x11-drivers/nvidia-drivers-96*$kernel_tag \
		=x11-drivers/nvidia-userspace-96*$kernel_tag
	## not working with >=xorg-server-1.5
	## ACCEPT_LICENSE="NVIDIA" equo install --fetch --nodeps ~x11-drivers/nvidia-drivers-71.86.*$kernel_tag
	mv /var/lib/entropy/client/packages/packages-nonfree/${mydir}/*/x11-drivers\:nvidia-{drivers,userspace}*.tbz2 \
		/install-data/drivers/

	# if we ship with ati-drivers, we have KMS disabled by default.
	# and better set driver arch to classic
	eselect mesa set r600 classic
}

setup_gnome_shell_extensions() {
	local extensions="windowlist@o2net.cl"
	for ext in ${extensions}; do
		eselect gnome-shell-extensions enable "${ext}"
	done
}

setup_fonts() {
	# Cause some rendering glitches on vbox as of 2011-10-02
	#	10-autohint.conf
	#	10-no-sub-pixel.conf
	#	10-sub-pixel-bgr.conf
	#	10-sub-pixel-rgb.conf
	#	10-sub-pixel-vbgr.conf
	#	10-sub-pixel-vrgb.conf
	#	10-unhinted.conf
	FONTCONFIG_ENABLE="
		20-unhint-small-dejavu-sans.conf
		20-unhint-small-dejavu-sans-mono.conf
		20-unhint-small-dejavu-serif.conf
		31-cantarell.conf
		52-infinality.conf
		57-dejavu-sans.conf
		57-dejavu-sans-mono.conf
		57-dejavu-serif.conf"
	for fc_en in ${FONTCONFIG_ENABLE}; do
		if [ -f "/etc/fonts/conf.avail/${fc_en}" ]; then
			# beautify font rendering
			eselect fontconfig enable "${fc_en}"
		else
			echo "ouch, /etc/fonts/conf.avail/${fc_en} is not available" >&2
		fi
	done
	# Complete infinality setup
	eselect infinality set infinality
	eselect lcdfilter set infinality
}

setup_misc_stuff() {
	# Setup SAMBA config file
	if [ -f /etc/samba/smb.conf.default ]; then
		cp -p /etc/samba/smb.conf.default /etc/samba/smb.conf
	fi

	# if Sabayon GNOME, drop qt-gui bins
	gnome_panel=$(qlist -ICve gnome-base/gnome-panel)
	if [ -n "${gnome_panel}" ]; then
		find /usr/share/applications -name "*qt-gui*.desktop" | xargs rm
	fi
	# we don't want this on our ISO
	rm -f /usr/share/applications/sandbox.desktop

	# beanshell app, not wanted in our start menu
	rm -f /usr/share/applications/bsh-console-bsh.desktop

	# drop gnome-system-log desktop file (broken)
	rm -f /usr/share/applications/gnome-system-log.desktop

	# Remove wicd from autostart
	rm -f /usr/share/autostart/wicd-tray.desktop /etc/xdg/autostart/wicd-tray.desktop

	# EXPERIMENTAL, clean icon cache files
	for file in $(find /usr/share/icons -name "icon-theme.cache"); do
		rm $file
	done

	# Regenerate Fluxbox menu
	if [ -x "/usr/bin/fluxbox-generate_menu" ]; then
		fluxbox-generate_menu -o /etc/skel/.fluxbox/menu
	fi
}

setup_installed_packages() {
	# Update package list
	equo query list installed -qv > /etc/sabayon-pkglist
	echo -5 | equo conf update

	echo "Vacuum cleaning client db"
	rm /var/lib/entropy/client/database/*/sabayonlinux.org -rf
	rm /var/lib/entropy/client/database/*/sabayon-weekly -rf
	equo rescue vacuum

	# restore original repositories.conf (all mirrors were filtered for speed)
	cp /etc/entropy/repositories.conf.example /etc/entropy/repositories.conf || exit 1
	for repo_conf in /etc/entropy/repositories.conf.d/entropy_*.example; do
		new_repo_conf="${repo_conf%.example}"
		cp "${repo_conf}" "${new_repo_conf}"
	done

	# cleanup log dir
	rm /var/lib/entropy/logs -rf
	rm -rf /var/lib/entropy/*cache*
	# remove entropy pid file
	rm -f /var/run/entropy/entropy.lock
	rm -f /var/lib/entropy/entropy.pid
	rm -f /var/lib/entropy/entropy.lock
}

setup_portage() {
	layman -d sabayon
	rm -rf /var/lib/layman/sabayon
	layman -d sabayon-distro
	rm -rf /var/lib/layman/sabayon-distro
	emaint --fix world
}

setup_startup_caches() {
	/lib/rc/bin/rc-depend -u
	# Generate openrc cache
	[[ -d "/lib/rc/init.d" ]] && touch /lib/rc/init.d/softlevel
	[[ -d "/run/openrc" ]] && touch /run/openrc/softlevel
	/etc/init.d/savecache start
	/etc/init.d/savecache zap
	ldconfig
	ldconfig
}

prepare_lxde() {
	setup_networkmanager
	# Fix ~/.dmrc to have it load LXDE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=LXDE" >> /etc/skel/.dmrc
	remove_desktop_files
	setup_displaymanager
	# properly tweak lxde autostart tweak, adding --desktop option
	sed -i 's/pcmanfm -d/pcmanfm -d --desktop/g' /etc/xdg/lxsession/LXDE/autostart
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_mate() {
        setup_networkmanager
	# Fix ~/.dmrc to have it load MATE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=mate" >> /etc/skel/.dmrc
        remove_desktop_files
        setup_displaymanager
        remove_mozilla_skel_cruft
        setup_cpufrequtils
        has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_e17() {
	setup_networkmanager
	# Fix ~/.dmrc to have it load E17
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=enlightenment" >> /etc/skel/.dmrc
	remove_desktop_files
	# E17 spin has chromium installed
	setup_displaymanager
	# Not using lxdm for now
	# TODO: improve the lines below
	# Make sure enlightenment is selected in lxdm
	# sed -i '/lxdm-greeter-gtk/ a\\nlast_session=enlightenment.desktop\nlast_lang=' /etc/lxdm/lxdm.conf
	# Fix ~/.gtkrc-2.0 for some nice icons in gtk
	echo 'gtk-icon-theme-name="Tango" gtk-theme-name="Xfce"' | tr " " "\n" > /etc/skel/.gtkrc-2.0
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_xfce() {
	setup_networkmanager
	# Fix ~/.dmrc to have it load Xfce
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=xfce" >> /etc/skel/.dmrc
	remove_desktop_files
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	setup_displaymanager
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_fluxbox() {
	setup_networkmanager
	# Fix ~/.dmrc to have it load Fluxbox
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=fluxbox" >> /etc/skel/.dmrc
	remove_desktop_files
	setup_displaymanager
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_gnome() {
	setup_networkmanager
	# Fix ~/.dmrc to have it load GNOME or Cinnamon
	echo "[Desktop]" > /etc/skel/.dmrc
	if [ -f "/usr/share/xsessions/cinnamon.desktop" ]; then
		echo "Session=cinnamon" >> /etc/skel/.dmrc
	else
		echo "Session=gnome" >> /etc/skel/.dmrc
		setup_gnome_shell_extensions
	fi
	rc-update del system-tools-backends boot
	rc-update add system-tools-backends default
	setup_displaymanager
	setup_sabayon_mce
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_xfceforensic() {
	setup_networkmanager
	# Fix ~/.dmrc to have it load Xfce
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=xfce" >> /etc/skel/.dmrc
	remove_desktop_files
	setup_cpufrequtils
	setup_displaymanager
	remove_mozilla_skel_cruft
	xfceforensic_remove_skel_stuff
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_kde() {
	setup_networkmanager
	# Fix ~/.dmrc to have it load KDE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=KDE-4" >> /etc/skel/.dmrc
	# Configure proper GTK3 theme
	# TODO: find a better solution?
	mv /etc/skel/.config/gtk-3.0/settings.ini._kde_molecule \
		/etc/skel/.config/gtk-3.0/settings.ini
	setup_displaymanager
	setup_sabayon_mce
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_awesome() {
	setup_networkmanager
	# Fix ~/.dmrc to have it load Awesome
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=awesome" >> /etc/skel/.dmrc
	remove_desktop_files
	setup_displaymanager
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_system() {
	local de="${1}"
	if [ "${de}" = "lxde" ]; then
		prepare_lxde
        elif [ "${de}" = "mate" ]; then
                prepare_mate
	elif [ "${de}" = "e17" ]; then
		prepare_e17
	elif [ "${de}" = "xfce" ]; then
		prepare_xfce
	elif [ "${de}" = "fluxbox" ]; then
		prepare_fluxbox
	elif [ "${de}" = "gnome" ]; then
		prepare_gnome
	elif [ "${de}" = "xfceforensic" ]; then
		prepare_xfceforensic
	elif [ "${de}" = "kde" ]; then
		prepare_kde
	elif [ "${de}" = "awesome" ]; then
		prepare_awesome
	fi
}

basic_environment_setup
setup_fonts
# setup Desktop Environment, might add packages
prepare_system "${1}"
# These have to run after prepare_system
setup_misc_stuff
setup_installed_packages
setup_portage
setup_startup_caches

exit 0
