#!/bin/sh

/usr/sbin/env-update
. /etc/profile

# FUTURE NOTE:
# this might get merged into remaster_generic_inner_chroot_script_after.sh
# once the Gaming Edition will be rebased on top of SpinBase, now it's based
# based on GNOME.

# Copy games icons on the desktop
for desktop_file in $(grep -rl "Categories=.*Game" /usr/share/applications/*); do
	desktop_name=$(basename "${desktop_file}")
	cp "${desktop_file}" "/etc/skel/Desktop/${desktop_name}" || exit 1
	chmod 755 "/etc/skel/Desktop/${desktop_name}" || exit 1
	chown root "/etc/skel/Desktop/${desktop_name}" || exit 1
done

echo -5 | equo conf update

rm /var/lib/entropy/client/database/*/sabayonlinux.org -rf
rm /var/lib/entropy/client/database/*/sabayon-weekly -rf
equo rescue vacuum
# cleanup logs and cache
rm /var/lib/entropy/logs -rf
rm -rf /var/lib/entropy/*cache*

exit 0
