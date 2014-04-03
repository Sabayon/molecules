#!/bin/sh

/usr/sbin/env-update
. /etc/profile

sd_enable() {
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload -f enable "${1}.service"
}

sd_disable() {
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload -f disable "${1}.service"
}

echo
echo "Configuring AMI root filesystem"
echo "Ext4 is the expected filesystem type"
echo "/dev/sda1 is the expected root filesystem partition"
echo "ec2-user is the expected user"
echo

# setup networking, make sure networkmanager is gone
sd_enable NetworkManager
sd_enable ModemManager

# drop other useless services
sd_disable sabayonlive

# Enable ssh
sd_enable sshd
# Enable cron
sd_enable vixie-cron

# delete root password, only ssh allowed
passwd -d root

# create ec2-user
useradd -d /home/ec2-user -k /etc/skel -g users -G wheel,disk,crontab \
	-m ec2-user || exit 1

# enable passwordless sudo for ec2-user
echo -e "\n# molecule generated rule\nec2-user ALL=NOPASSWD: ALL" \
	>> /etc/sudoers

# setup fstab
echo "# molecule generated fstab
LABEL=/ / ext4 defaults 1 1
none /dev/shm tmpfs defaults 0 0" > /etc/fstab

# setup networking, reset /etc/conf.d/net
echo > /etc/conf.d/net

echo -5 | equo conf update
mount -t proc proc /proc

export ETP_NONINTERACTIVE=1

# setup kernel
eselect bzimage set 1 || exit 1

rm -f /boot/grub/grub.{cfg,conf}*
echo "
default=0
fallback=1
timeout=3
hiddenmenu

title Sabayon Linux AMI (PV)
root (hd0)
kernel /boot/bzImage root=LABEL=/ console=hvc0 rootfstype=ext4
initrd /boot/Initrd
" > /boot/grub/grub.conf
( cd /boot/grub && ln -sf grub.conf menu.lst ) || exit 1

# Generate list of installed packages
equo query list installed -qv > /etc/sabayon-pkglist

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
# cleanup install-data dir
rm -rf /install-data

ldconfig
ldconfig
umount /proc


# remove hw hash
rm -f /etc/entropy/.hw.hash
# remove entropy pid file
rm -f /var/run/entropy/entropy.lock

# remove /run/* and /var/lock/*
# systemd mounts them using tmpfs
rm -rf /run/*
rm -rf /var/lock/*

exit 0
