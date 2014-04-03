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
echo "Configuring AMI chroot"
echo

# setup networking, make sure networkmanager is gone
sd_disable NetworkManager

# drop other useless services
sd_disable sabayonlive

# Enable ssh
sd_enable sshd

# delete root password, only ssh allowed
passwd -d root

# setup fstab
# TODO: really needed?
echo "# molecule generated fstab
/dev/sda1 / ext3 defaults 1 1
/dev/sdb /mnt ext3 defaults 0 0
none /dev/shm tmpfs defaults 0 0" > /etc/fstab

echo -5 | equo conf update
mount -t proc proc /proc

export ETP_NONINTERACTIVE=1

# need to install grub-1
equo install sys-boot/grub:0 || exit 1
# remove grub-2
equo remove sys-boot/grub:2 --nodeps --force-system || exit 1

# configure grub-1 config
kernel_bin=$(ls /boot/kernel-genkernel-* | sort | tail -n 1)
# we need a bzImage
#initrd_bin=$(ls /boot/initramfs-genkernel-* | sort | tail -n 1)
rm -f /boot/grub/grub.cfg
echo "default 0
timeout 3
title EC2
root (hd0)
kernel ${kernel_bin} root=/dev/sda1
" > /boot/grub/grub.conf
# initrd ${initrd_bin}

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
