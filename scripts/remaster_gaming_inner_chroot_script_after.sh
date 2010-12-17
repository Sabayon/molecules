#!/bin/sh

# FUTURE NOTE:
# this might get merged into remaster_generic_inner_chroot_script_after.sh
# once the Gaming Edition will be rebased on top of SpinBase, now it's based
# based on GNOME.

# Not shipping xbmc
rm /etc/skel/Desktop/xbmc.desktop || exit 1

# Copy games icons on the desktop
for desktop_file in $(grep -rl "Categories=.*Game" /usr/share/applications/*); do
	desktop_name=$(basename "${desktop_file}")
	cp "${desktop_file}" "/etc/skel/Desktop/${desktop_name}" || exit 1
	chmod 755 "/etc/skel/Desktop/${desktop_name}" || exit 1
	chown root "/etc/skel/Desktop/${desktop_name}" || exit 1
done

exit 0
