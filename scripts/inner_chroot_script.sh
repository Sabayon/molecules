#!/bin/bash

/usr/sbin/env-update
. /etc/profile

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

# create /proc if it doesn't exist
# rsync doesn't copy it
mkdir -p /proc
# do not create /proc/.keep or older anaconda will raise an exception
# touch /proc/.keep
rm -f /proc/.keep
mkdir -p /dev/shm
touch /dev/shm/.keep
mkdir -p /dev/pts
touch /dev/pts/.keep

# Cleanup Perl cruft
perl-cleaner --ph-clean

# copy /root defaults from /etc/skel
rm -rf /root
cp /etc/skel /root -Rap
chown root:root /root -R

# Setup locale to en_US
for f in /etc/env.d/02locale /etc/locale.conf; do
	echo LANG=en_US.UTF-8 > "${f}"
	echo LANGUAGE=en_US.UTF-8 >> "${f}"
	echo LC_ALL=en_US.UTF-8 >> "${f}"
done
# Needed by systemd, because it doesn't properly set a good
# encoding in ttys. Test it with (on tty1, VT1):
# echo -e "\xE2\x98\xA0"
# TODO: check if the issue persists with systemd 202.
echo FONT=LatArCyrHeb-16 > /etc/vconsole.conf

# since this comes without X, set the default target to multi-user.target
# instead of graphical.target
sd_enable multi-user target

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
# allow root logins to the livecd by default
# turn bashlogin shells to actual login shells
sed -i 's:exec -l /bin/bash:exec -l /bin/bash -l:' /bin/bashlogin

# setup /etc/hosts, add sabayon as default hostname (required by Xfce)
sed -i "/^127.0.0.1/ s/localhost/localhost sabayon/" /etc/hosts
sed -i "/^::1/ s/localhost/localhost sabayon/" /etc/hosts

# setup postfix local mail aliases
newaliases

# DO NOT ENABLE interactive startup !!!
# At this time, plymouth will trigger openrc interactive
# mode if it's not forced to NO. So, disable it completely
# sed -i "/^#rc_interactive=/ s/#//" /etc/rc.conf

# Set Plymouth default theme, newer artwork has the sabayon theme
is_ply_sabayon=$(plymouth-set-default-theme --list | grep sabayon)
if [ -n "${is_ply_sabayon}" ]; then
	plymouth-set-default-theme sabayon
else
	plymouth-set-default-theme solar
fi

# enable cd eject on shutdown/reboot
sd_enable cdeject

# Activate services for systemd
SYSTEMD_SERVICES=(
	"NetworkManager"
	"sabayonlive"
	"installer-text"
	"installer-gui"
)
for srv in "${SYSTEMD_SERVICES[@]}"; do
	sd_enable "${srv}"
done
# Disable syslog in systemd, we use journald
sd_disable syslog-ng

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

echo "Vacuum cleaning client db"
equo rescue vacuum

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
for conf in package.mask package.unmask package.keywords make.conf package.use; do
	repo_path=/var/lib/entropy/client/database/*/sabayonlinux.org/standard
	repo_conf=$(ls -1 ${repo_path}/*/*/${conf} | sort | tail -n 1 2>/dev/null)
	if [ -n "${repo_conf}" ]; then
		target_path="/etc/portage/${conf}"
		if [ ! -d "${target_path}" ]; then # do not touch dirs
			cp "${repo_conf}" "${target_path}" # ignore
		fi
	fi
done
# split config files
for conf in 00-sabayon.package.use 00-sabayon.package.mask \
	00-sabayon.package.unmask 00-sabayon.package.keywords; do
	repo_path=/var/lib/entropy/client/database/*/sabayonlinux.org/standard
	repo_conf=$(ls -1 ${repo_path}/*/*/${conf} | sort | tail -n 1 2>/dev/null)
	if [ -n "${repo_conf}" ]; then
		target_path="/etc/portage/${conf/00-sabayon.}/${conf}"
		target_dir=$(dirname "${target_path}")
		if [ -f "${target_dir}" ]; then # remove old file
			rm "${target_dir}" # ignore failure
		fi
		if [ ! -d "${target_path}" ]; then
			mkdir -p "${target_path}" # ignore failure
		fi
		cp "${repo_conf}" "${target_path}" # ignore

	fi
done

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
rm -rf /var/lib/entropy/*cache*

# remove entropy hwhash
rm -f /etc/entropy/.hw.hash

# remove entropy pid file
rm -f /var/run/entropy/entropy.lock
rm -f /var/lib/entropy/entropy.pid
rm -f /var/lib/entropy/entropy.lock # old?

# remove /run/* and /var/lock/*
# systemd mounts them using tmpfs
rm -rf /run/*
rm -rf /var/lock/*

exit 0
