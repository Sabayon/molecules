#!/bin/bash

/usr/sbin/env-update
. /etc/profile

_get_kernel_tag() {
	local kernel_ver="$(equo match --installed -qv virtual/linux-binary | cut -d/ -f 2)"
	# strip -r** if exists, hopefully we don't have PN ending with -r
	local kernel_ver="${kernel_ver%-r*}"
	local kernel_tag_file="/etc/kernels/${kernel_ver}/RELEASE_LEVEL"
	if [ ! -f "${kernel_tag_file}" ]; then
		echo "cannot find ${kernel_tag_file}, wtf" >&2
	else
		echo "#$(cat "${kernel_tag_file}")"
	fi
}

install_kernel_packages() {
	local kernel_tag=$(_get_kernel_tag)
	local pkgs=()
	for pkg in "${@}"; do
		pkgs+=( "${pkg}${kernel_tag}" )
	done
	equo install "${pkgs[@]}"
}

sd_enable() {
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload enable -f "${1}.service"
}

sd_disable() {
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload disable -f "${1}.service"
}

basic_environment_setup() {
	eselect opengl set xorg-x11 &> /dev/null

	# automatically start xdm
	rc-update del xdm default
	rc-update del xdm boot
	rc-update add xdm boot
	# systemd has specific targets depending on the DM

	# consolekit must be run at boot level
	rc-update add consolekit boot
	# systemd uses logind

	rc-update del sabayon-mce default
	sd_disable sabayon-mce
	rc-update add nfsmount default

	# setup avahi
	rc-update add avahi-daemon default
	sd_enable avahi-daemon

	local kern_type="$(equo match --installed -q virtual/linux-binary)"
	local do_zfs=1
	if [ ! -f /etc/init.d/zfs ]; then
		do_zfs=0
	elif [ "$(uname -m)" != "x86_64" ]; then
		do_zfs=0
	elif [ "${kern_type}" = "sys-kernel/linux-hardened" ]; then
		do_zfs=0  # currently not in the hardened kernel
	fi
	if [ "${do_zfs}" = "1" ]; then
		rc-update add zfs boot
		sd_enable zfs
	fi

	# Create a default "games" group so that
	# the default user will be added to it during
	# live boot, and thus, after install.
	# See bug 3134
	groupadd -f games

	# all these images come with X.Org
	sd_enable graphical
}

setup_cpufrequtils() {
	rc-update add cpufrequtils default
	sd_enable cpufrequtils
}

setup_sabayon_mce() {
	rc-update add sabayon-mce boot
	sd_enable sabayon-mce
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
		sd_enable gdm
	elif [ -n "$(equo match --installed lxde-base/lxdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="lxdm"/g' /etc/conf.d/xdm
		sd_enable lxdm
	elif [ -n "$(equo match --installed x11-misc/lightdm-base -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="lightdm"/g' /etc/conf.d/xdm
		sd_enable lightdm
	elif [ -n "$(equo match --installed kde-base/kdm -qv)" ]; then
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="kdm"/g' /etc/conf.d/xdm
		sd_enable kdm
	else
		sed -i 's/DISPLAYMANAGER=".*"/DISPLAYMANAGER="xdm"/g' /etc/conf.d/xdm
		sd_enable xdm
	fi
}

setup_default_xsession() {
	local sess="${1}"
	ln -sf "${sess}.desktop" /usr/share/xsessions/default.desktop
}

setup_networkmanager() {
	rc-update del NetworkManager default
	rc-update del NetworkManager
	rc-update add NetworkManager default
	rc-update add NetworkManager-setup default
	sd_enable NetworkManager
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

setup_virtualbox() {
	install_kernel_packages \
		"app-emulation/virtualbox-guest-additions" \
		"x11-drivers/xf86-video-virtualbox"
	rc-update add virtualbox-guest-additions boot
	sd_enable virtualbox-guest-additions
}

install_proprietary_gfx_drivers() {
	install_kernel_packages "x11-drivers/ati-drivers" \
		"x11-drivers/nvidia-drivers"
}

setup_proprietary_gfx_drivers() {
	# Prepare NVIDIA legacy drivers infrastructure

	if [ ! -d "/install-data/drivers" ]; then
		mkdir -p /install-data/drivers
	fi

	local myuname=$(uname -m)
	local mydir="x86"
	if [ "$myuname" == "x86_64" ]; then
		mydir="amd64"
	fi
	local kernel_tag=$(_get_kernel_tag)

	rm -rf /var/lib/entropy/client/packages/packages*/${mydir}/*/x11-drivers*

	equo install --fetch --nodeps =x11-drivers/nvidia-userspace-304* \
		=x11-drivers/nvidia-drivers-304*$kernel_tag
	equo install --fetch --nodeps =x11-drivers/nvidia-userspace-173* \
		=x11-drivers/nvidia-drivers-173*$kernel_tag

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
	install_proprietary_gfx_drivers
	setup_virtualbox
	setup_networkmanager
	# Fix ~/.dmrc to have it load LXDE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=LXDE" >> /etc/skel/.dmrc
	setup_default_xsession "LXDE"
	setup_displaymanager
	# properly tweak lxde autostart tweak, adding --desktop option
	sed -i 's/pcmanfm -d/pcmanfm -d --desktop/g' /etc/xdg/lxsession/LXDE/autostart
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_mate() {
	install_proprietary_gfx_drivers
	setup_virtualbox
	setup_networkmanager
	# Fix ~/.dmrc to have it load MATE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=mate" >> /etc/skel/.dmrc
	setup_default_xsession "mate"
	setup_displaymanager
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_e17() {
	install_proprietary_gfx_drivers
	setup_virtualbox
	setup_networkmanager
	# Fix ~/.dmrc to have it load E17
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=enlightenment" >> /etc/skel/.dmrc
	setup_default_xsession "enlightenment"
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
	install_proprietary_gfx_drivers
	setup_virtualbox
	setup_networkmanager
	# Fix ~/.dmrc to have it load Xfce
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=xfce" >> /etc/skel/.dmrc
	setup_default_xsession "xfce"
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	setup_displaymanager
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_fluxbox() {
	install_proprietary_gfx_drivers
	setup_virtualbox
	setup_networkmanager
	# Fix ~/.dmrc to have it load Fluxbox
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=fluxbox" >> /etc/skel/.dmrc
	setup_default_xsession "fluxbox"
	setup_displaymanager
	remove_mozilla_skel_cruft
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_gnome() {
	install_proprietary_gfx_drivers
	setup_virtualbox
	setup_networkmanager
	# Fix ~/.dmrc to have it load GNOME or Cinnamon
	echo "[Desktop]" > /etc/skel/.dmrc
	if [ -f "/usr/share/xsessions/cinnamon.desktop" ]; then
		echo "Session=cinnamon" >> /etc/skel/.dmrc
	setup_default_xsession "cinnamon"
	else
		echo "Session=gnome" >> /etc/skel/.dmrc
		setup_gnome_shell_extensions
	setup_default_xsession "gnome"
	fi
	rc-update del system-tools-backends boot
	rc-update add system-tools-backends default
	# no systemd counterpart

	setup_displaymanager
	setup_sabayon_mce
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_xfceforensic() {
	install_proprietary_gfx_drivers
	setup_networkmanager
	# Fix ~/.dmrc to have it load Xfce
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=xfce" >> /etc/skel/.dmrc
	setup_default_xsession "xfce"
	setup_cpufrequtils
	setup_displaymanager
	remove_mozilla_skel_cruft
	xfceforensic_remove_skel_stuff
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_kde() {
	install_proprietary_gfx_drivers
	setup_virtualbox
	setup_networkmanager
	# Fix ~/.dmrc to have it load KDE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=KDE-4" >> /etc/skel/.dmrc
	setup_default_xsession "KDE-4"
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
	install_proprietary_gfx_drivers
	setup_virtualbox
	setup_networkmanager
	# Fix ~/.dmrc to have it load Awesome
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=awesome" >> /etc/skel/.dmrc
	setup_default_xsession "awesome"
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
