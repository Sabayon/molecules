#!/bin/bash

# do not remove these
/usr/sbin/env-update
source /etc/profile

eselect opengl set xorg-x11 &> /dev/null

# automatically start xdm
rc-update del xdm default
rc-update del xdm boot
rc-update add xdm boot

# consolekit must be run at boot level
rc-update add consolekit boot

rc-update del hald boot
rc-update del hald
rc-update add hald boot

rc-update del NetworkManager default
rc-update del NetworkManager
rc-update add NetworkManager default

rc-update del music boot
rc-update add music default

rc-update del sabayon-mce default

rc-update add nfsmount default

# Always startup this
rc-update add virtualbox-guest-additions boot

remove_desktop_files() {
	rm /etc/skel/Desktop/WorldOfGooDemo-world-of-goo-demo.desktop
	rm /etc/skel/Desktop/fusion-icon.desktop
	rm /etc/skel/Desktop/xbmc.desktop
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

nspluginwrapper_autoinstall() {
	if [ -x /usr/bin/nspluginwrapper ]; then
		echo "Auto installing 32bit ns plugins..."
		nspluginwrapper -a -i
		ls /usr/lib/nsbrowser/plugins

		# Remove wrappers if equivalent 64-bit plugins exist
		# TODO: May be better to patch nspluginwrapper so it doesn't create
		#       duplicate wrappers in the first place...
		local DIR64="/usr/lib/nsbrowser/plugins/"
		for f in "${DIR64}"/npwrapper.*.so; do
			local PLUGIN=${f##*/npwrapper.}
			if [[ -f ${DIR64}/${PLUGIN} ]]; then
				echo "  Removing duplicate wrapper for native 64-bit ${PLUGIN}"
				nspluginwrapper -r "${f}"
			fi
		done
	fi
}

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

gforensic_remove_skel_stuff() {
	# remove desktop icons
	rm /etc/skel/Desktop/*
	# remove no longer needed folders/files
	rm -r /etc/skel/.fluxbox
	rm -r /etc/skel/.e
	rm -r /etc/skel/.kde4
	rm -r /etc/skel/.mozilla
	rm -r /etc/skel/.emerald
	rm -r /etc/skel/.xchat2
	rm -r /etc/skel/.config/compiz
	rm -r /etc/skel/.config/lxpanel
	rm -r /etc/skel/.config/pcmanfm
	rm -r /etc/skel/.config/Thunar
	rm -r /etc/skel/.config/xfce4
	rm -r /etc/skel/.gconf/apps/compiz
	rm -r /etc/skel/.gconf/apps/gset-compiz
	rm /etc/skel/.config/menus/applications-kmenuedit.menu
	rm /etc/skel/.kderc
}

if [ "$1" = "lxde" ]; then
	# Fix ~/.dmrc to have it load LXDE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=LXDE" >> /etc/skel/.dmrc
	remove_desktop_files
	setup_displaymanager
	# properly tweak lxde autostart tweak, adding --desktop option
	sed -i 's/pcmanfm -d/pcmanfm -d --desktop/g' /etc/xdg/lxsession/LXDE/autostart
	setup_cpufrequtils
elif [ "$1" = "e17" ]; then
	# Fix ~/.dmrc to have it load E17
        echo "[Desktop]" > /etc/skel/.dmrc
        echo "Session=enlightenment" >> /etc/skel/.dmrc
        remove_desktop_files
	setup_displaymanager
	# TODO: improve the lines below
	# Make sure enlightenment is selected in lxdm
	sed -i '/lxdm-greeter-gtk/ a\\nlast_session=enlightenment.desktop\nlast_lang=' /etc/lxdm/lxdm.conf
	# Fix ~/.gtkrc-2.0 for some nice icons in gtk
	echo 'gtk-icon-theme-name="Tango" gtk-theme-name="Xfce"' | tr " " "\n" > /etc/skel/.gtkrc-2.0
	setup_cpufrequtils
elif [ "$1" = "xfce" ]; then
	# Fix ~/.dmrc to have it load XFCE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=xfce" >> /etc/skel/.dmrc
	remove_desktop_files
	setup_cpufrequtils
	setup_displaymanager
elif [ "$1" = "fluxbox" ]; then
	# Fix ~/.dmrc to have it load Fluxbox
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=fluxbox" >> /etc/skel/.dmrc
	remove_desktop_files
	setup_displaymanager
	setup_cpufrequtils
elif [ "$1" = "gnome" ]; then
	# Fix ~/.dmrc to have it load GNOME
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=gnome" >> /etc/skel/.dmrc
	SHIP_NVIDIA_LEGACY="1"
	rc-update del system-tools-backends boot
	rc-update add system-tools-backends default
	setup_displaymanager
	setup_sabayon_mce
elif [ "$1" = "gforensic" ]; then
	# Fix ~/.dmrc to have it load GNOME
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=gnome" >> /etc/skel/.dmrc
	SHIP_NVIDIA_LEGACY="1"
	rc-update del system-tools-backends boot
	rc-update add system-tools-backends default
	setup_displaymanager
	setup_sabayon_mce
	gforensic_remove_skel_stuff
elif [ "$1" = "kde" ]; then
	# Fix ~/.dmrc to have it load KDE
	echo "[Desktop]" > /etc/skel/.dmrc
	echo "Session=KDE-4" >> /etc/skel/.dmrc
	SHIP_NVIDIA_LEGACY="1"
	setup_displaymanager
	setup_sabayon_mce
fi

if [ -n "${SHIP_NVIDIA_LEGACY}" ]; then
	# Prepare NVIDIA legacy drivers infrastructure

	if [ ! -d "/install-data/drivers" ]; then
        	mkdir -p /install-data/drivers
	fi
	myuname=$(uname -m)
	mydir="x86"
	if [ "$myuname" == "x86_64" ]; then
        	mydir="amd64"
	fi
	kernel_tag="#$(equo match --installed -qv sys-kernel/linux-sabayon | sort | head -n 1 | cut -d"-" -f 4 | sed 's/ //g')-sabayon"

	rm -rf /var/lib/entropy/client/packages/packages*/${mydir}/*/x11-drivers*
	ACCEPT_LICENSE="NVIDIA" equo install --fetch --nodeps =x11-drivers/nvidia-drivers-173*$kernel_tag
	# not working with >=xorg-server-1.8
	# ACCEPT_LICENSE="NVIDIA" equo install --fetch --nodeps =x11-drivers/nvidia-drivers-96*$kernel_tag
	# not working with >=xorg-server-1.5
	# ACCEPT_LICENSE="NVIDIA" equo install --fetch --nodeps ~x11-drivers/nvidia-drivers-71.86.*$kernel_tag
	mv /var/lib/entropy/client/packages/packages-nonfree/${mydir}/*/x11-drivers\:nvidia-drivers*.tbz2 /install-data/drivers/

	# Add fusion icon to desktop
	if [ -f "/usr/share/applications/fusion-icon.desktop" ]; then
		cp /usr/share/applications/fusion-icon.desktop /etc/skel/Desktop/
	fi
fi

# !!! THERE IS A BUG IN THE CLAMAV EBUILD !!!
# fix clamav shit if available, mainly for Gforensic
if [ ! -d "/var/log/clamav" ]; then
	mkdir -p /var/log/clamav
	chown clamav:clamav /var/log/clamav
fi
touch /var/log/clamav/freshclam.log
chown clamav:clamav /var/log/clamav -R
chown clamav:clamav /var/lib/clamav -R

# Fixup mysqld permissions, ebuild bug?
if [ -d "/var/run/mysqld" ]; then
	chown mysql:mysql /var/run/mysqld -R
fi

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

# Remove wicd from autostart
rm -f /usr/share/autostart/wicd-tray.desktop /etc/xdg/autostart/wicd-tray.desktop

# EXPERIMENTAL, clean icon cache files
for file in `find /usr/share/icons -name "icon-theme.cache"`; do
        rm $file
done

# Fixup nsplugins
# we have new Flash, don't need it anymore
# nspluginwrapper_autoinstall

# Update package list
equo query list installed -qv > /etc/sabayon-pkglist

# Setup basic GTK theme for root user
if [ ! -f "/root/.gtkrc-2.0" ]; then
	echo "include \"/usr/share/themes/Clearlooks/gtk-2.0/gtkrc\"" > /root/.gtkrc-2.0
fi

# Regenerate Fluxbox menu
if [ -x "/usr/bin/fluxbox-generate_menu" ]; then
	fluxbox-generate_menu -o /etc/skel/.fluxbox/menu
fi

layman -d sabayon
rm -rf /var/lib/layman/sabayon


echo -5 | equo conf update
mount -t proc proc /proc
/lib/rc/bin/rc-depend -u

echo "Vacuum cleaning client db"
rm /var/lib/entropy/client/database/*/sabayonlinux.org -rf
equo rescue vacuum

# cleanup log dir
rm /var/lib/entropy/logs -rf

# Generate openrc cache
/etc/init.d/savecache start
/etc/init.d/savecache zap

ldconfig
ldconfig
umount /proc

equo deptest --pretend
emaint --fix world

rm -rf /var/lib/entropy/*cache*

exit 0
