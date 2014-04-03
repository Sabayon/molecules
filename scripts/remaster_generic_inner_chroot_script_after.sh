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

install_packages() {
	equo install "${@}"
}

install_kernel_packages() {
	local kernel_tag=$(_get_kernel_tag)
	local pkgs=()
	for pkg in "${@}"; do
		pkgs+=( "${pkg}${kernel_tag}" )
	done
	install_packages "${pkgs[@]}"
}

sd_enable() {
	local srv="${1}"
	local ext=".${2:-service}"
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload enable -f "${srv}${ext}"
}

sd_disable() {
	local srv="${1}"
	local ext=".${2:-service}"
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload disable -f "${srv}${ext}"
}

basic_environment_setup() {
	eselect opengl set xorg-x11
	eselect mesa set --auto

	sd_disable sabayon-mce

	# setup avahi
	sd_enable avahi-daemon

	# setup printing
	sd_enable cups
	sd_enable cups-browsed

	# Create a default "games" group so that
	# the default user will be added to it during
	# live boot, and thus, after install.
	# See bug 3134
	groupadd -f games

	# all these images come with X.Org
	sd_enable graphical target
}

setup_cpufrequtils() {
	sd_enable cpufrequtils
}

setup_sabayon_mce() {
	sd_enable sabayon-mce
}

setup_sabayon_steambox() {
	sd_enable steambox
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
		sd_enable gdm
	elif [ -n "$(equo match --installed lxde-base/lxdm -qv)" ]; then
		sd_enable lxdm
	elif [ -n "$(equo match --installed x11-misc/lightdm-base -qv)" ]; then
		sd_enable lightdm
	elif [ -n "$(equo match --installed kde-base/kdm -qv)" ]; then
		sd_enable kdm
	else
		sd_enable xdm
	fi
}

setup_default_xsession() {
	local sess="${1}"
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=${sess}" >> /etc/skel/.dmrc
	ln -sf "${sess}.desktop" /usr/share/xsessions/default.desktop
}

setup_networkmanager() {
	sd_enable NetworkManager
	sd_enable ModemManager
}

xfceforensic_remove_skel_stuff() {
	# remove no longer needed folders/files
	rm -rf /etc/skel/.config/xfce4/desktop
	rm -rf /etc/skel/.config/xfce4/panel
	rm -rf /etc/skel/Desktop/*
	rm -rf /usr/share/backgrounds/iottinka
	rm -rf /usr/share/wallpapers/*
}

setup_oss_gfx_drivers() {
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
	sd_enable virtualbox-guest-additions
}

install_external_kernel_modules() {
	install_kernel_packages \
		"app-laptop/nvidiabl" \
		"net-wireless/ndiswrapper" \
		"sys-fs/zfs-kmod" \
		"sys-power/bbswitch" \
		"net-wireless/broadcom-sta" || return 1
	# otherwise bbswitch is useless
	install_packages "x11-misc/bumblebee"
}

install_proprietary_gfx_drivers() {
	install_kernel_packages "x11-drivers/ati-drivers" \
		"x11-drivers/nvidia-drivers"
}

setup_proprietary_gfx_drivers() {
	local myuname=$(uname -m)
	local mydir="x86"
	if [ "${myuname}" == "x86_64" ]; then
		mydir="amd64"
	fi
	local kernel_tag=$(_get_kernel_tag)
	local pkgs_dir=/var/lib/entropy/client/packages
	local cd_dir=/install-data/drivers
	local pkgs=(
		"=x11-drivers/nvidia-userspace-304*"
		"=x11-drivers/nvidia-drivers-304*${kernel_tag}"
		"=x11-drivers/nvidia-userspace-173*"
		"=x11-drivers/nvidia-drivers-173*${kernel_tag}"
	)
	local ts=
	local tp=
	local pkg_f=

	mkdir -p "${cd_dir}" || return 1
	equo download --nodeps "${pkgs[@]}" || return 1

	OLDIFS=${IFS}
	IFS='
'
	local data=( $(equo match --quiet --showdownload "${pkgs[@]}") )
	IFS=${OLDIFS}
	for ts in "${data[@]}"; do
		tp=( ${ts} )
		pkg_f="${pkgs_dir}/${tp[1]}"
		echo "Copying ${pkg_f} to ${cd_dir}"
		cp "${pkg_f}" "${cd_dir}"/
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
	ldconfig
}

prepare_generic() {
	install_proprietary_gfx_drivers
	install_external_kernel_modules
	setup_virtualbox
	setup_networkmanager
	setup_displaymanager
	setup_cpufrequtils
	has_proprietary_drivers && setup_proprietary_gfx_drivers || setup_oss_gfx_drivers
}

prepare_lxde() {
	setup_default_xsession "LXDE"
	# properly tweak lxde autostart tweak, adding --desktop option
	sed -i 's/pcmanfm -d/pcmanfm -d --desktop/g' /etc/xdg/lxsession/LXDE/autostart
}

prepare_mate() {
	setup_default_xsession "mate"
}

prepare_e17() {
	setup_default_xsession "enlightenment"
	# E17 spin has chromium installed
	# Not using lxdm for now
	# TODO: improve the lines below
	# Make sure enlightenment is selected in lxdm
	# sed -i '/lxdm-greeter-gtk/ a\\nlast_session=enlightenment.desktop\nlast_lang=' /etc/lxdm/lxdm.conf
	# Fix ~/.gtkrc-2.0 for some nice icons in gtk
	echo 'gtk-icon-theme-name="Tango" gtk-theme-name="Xfce"' | tr " " "\n" > /etc/skel/.gtkrc-2.0
}

prepare_xfce() {
	setup_default_xsession "xfce"

	# Enable AWN config for Xfce
	mv /etc/skel/.gconf/apps/awn-applet-taskmanager/{xfce-,}%gconf.xml
}

prepare_fluxbox() {
	setup_default_xsession "fluxbox"
}

prepare_gnome() {
	if [ -f "/usr/share/xsessions/cinnamon.desktop" ]; then
		setup_default_xsession "cinnamon"
	else
		setup_default_xsession "gnome"
	fi

	setup_sabayon_mce
	setup_sabayon_steambox
}

prepare_xfceforensic() {
	setup_default_xsession "xfce"
	xfceforensic_remove_skel_stuff
}

prepare_kde() {
	setup_default_xsession "KDE-4"
	# Configure proper GTK3 theme
	# TODO: find a better solution?
	mv /etc/skel/.config/gtk-3.0/settings.ini._kde_molecule \
		/etc/skel/.config/gtk-3.0/settings.ini
	setup_sabayon_mce
	setup_sabayon_steambox
}

prepare_awesome() {
	setup_default_xsession "awesome"
}

prepare_system() {
	prepare_generic
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
