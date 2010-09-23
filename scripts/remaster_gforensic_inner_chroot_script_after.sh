#!/bin/sh

# call parent script first
/sabayon/scripts/remaster_generic_inner_chroot_script_after.sh $@

touch /var/log/clamav/freshclam.log
chown clamav:clamav /var/log/clamav -R

# do custom stuff
#remove desktop icons
rm /etc/skel/Desktop/*
#remove no longer needed folders/files
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

