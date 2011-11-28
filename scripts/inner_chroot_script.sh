#!/bin/bash

# create /proc if it doesn't exist
# rsync doesn't copy it
if [ ! -d "/proc" ]; then
	mkdir /proc
	touch /proc/.keep
fi
if [ ! -d "/dev/pts" ]; then
	mkdir /dev/pts
	touch /dev/pts/.keep
fi

# Cleanup Perl cruft
perl-cleaner --ph-clean

# copy /root defaults from /etc/skel
rm -rf /root
cp /etc/skel /root -Rap
chown root:root /root -R

source /etc/profile
/usr/sbin/env-update && source /etc/profile

# Setup locale to en_US
echo LANG=\"en_US.UTF-8\" > /etc/env.d/02locale
echo LANGUAGE=\"en_US.UTF-8\" >> /etc/env.d/02locale
echo LC_ALL=\"en_US.UTF-8\" >> /etc/env.d/02locale

# remove SSH keys
rm -rf /etc/ssh/*_key*

# remove LDAP keys
rm -f /etc/openldap/ssl/ldap.pem /etc/openldap/ssl/ldap.key \
	/etc/openldap/ssl/ldap.csr /etc/openldap/ssl/ldap.crt

# better remove postfix package manager generated
# SSL certificates
rm -rf /etc/ssl/postfix/server.*

# make sure postfix only listens on localhost
echo "inet_interfaces = localhost" >> /etc/postfix/main.cf
# do not add it yet to runlevel
# rc-update add postfix default

# allow root logins to the livecd by default
# turn bashlogin shells to actual login shells
sed -i 's:exec -l /bin/bash:exec -l /bin/bash -l:' /bin/bashlogin

# setup /etc/hosts, add sabayon as default hostname (required by Xfce)
sed -i "/^127.0.0.1/ s/localhost/localhost sabayon/" /etc/hosts
sed -i "/^::1/ s/localhost/localhost sabayon/" /etc/hosts

# setup postfix local mail aliases
newaliases

# enable cd eject on shutdown/reboot
rc-update add cdeject shutdown

# setup sudoers
[ -e /etc/sudoers ] && sed -i '/NOPASSWD: ALL/ s/^# //' /etc/sudoers

# setup opengl in /etc (if configured)
eselect opengl set xorg-x11 &> /dev/null

# touch /etc/asound.state
touch /etc/asound.state

update-pciids
update-usbids

echo -5 | etc-update
mount -t proc proc /proc
/lib/rc/bin/rc-depend -u

echo "Vacuum cleaning client db"
equo rescue vacuum

# Generate openrc cache
touch /lib/rc/init.d/softlevel
/etc/init.d/savecache start
/etc/init.d/savecache zap

ldconfig
ldconfig
umount /proc

equo deptest --pretend
emaint --fix world

# copy entropy repositories config
# the one in chroots is optimized to use Garr mirror
cp /etc/entropy/repositories.conf.example /etc/entropy/repositories.conf -p
for repo_conf in /etc/entropy/repositories.conf.d/entropy_*.example; do
	new_repo_conf="${repo_conf%.example}"
	cp "${repo_conf}" "${new_repo_conf}"
done

# copy Portage config from sabayonlinux.org entropy repo to system
cp /var/lib/entropy/client/database/*/sabayonlinux.org/standard/*/*/package.mask /etc/portage/package.mask
cp /var/lib/entropy/client/database/*/sabayonlinux.org/standard/*/*/package.unmask /etc/portage/package.unmask
cp /var/lib/entropy/client/database/*/sabayonlinux.org/standard/*/*/package.use /etc/portage/package.use
cp /var/lib/entropy/client/database/*/sabayonlinux.org/standard/*/*/make.conf /etc/make.conf

# Update sabayon overlay
layman -d sabayon
rm -rf /var/lib/layman/sabayon
layman -d sabayon-distro
rm -rf /var/lib/layman/sabayon-distro

# Reset users' password
# chpasswd doesn't work anymore
root_zeropass="root::$(cat /etc/shadow | grep "root:" | cut -d":" -f3-)"
sed -i "s/^root:.*/${root_zeropass}/" /etc/shadow

# protect /var/tmp
touch /var/tmp/.keep
touch /tmp/.keep
chmod 777 /var/tmp
chmod 777 /tmp

# Looks like screen directories are missing
if [ ! -d "/var/run/screen" ]; then
	mkdir /var/run/screen
	chmod 775 /var/run/screen
	chown root:utmp /var/run/screen
fi

# Regenerate Fluxbox menu
if [ -x "/usr/bin/fluxbox-generate_menu" ]; then
        fluxbox-generate_menu -o /etc/skel/.fluxbox/menu
fi

equo query list installed -qv > /etc/sabayon-pkglist

rm -rf /var/tmp/entropy/*
rm -rf /var/lib/entropy/logs
rm -rf /var/lib/entropy/glsa
rm -rf /var/lib/entropy/tmp

# remove entropy hwhash
rm -f /etc/entropy/.hw.hash

# remove entropy pid file
rm -f /var/run/entropy/entropy.lock

exit 0
