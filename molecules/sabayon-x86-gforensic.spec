# Sabayon Linux 5 x86 GNOME Molecule remaster spec file
# The aim of this spec file is to add arbitrary applications & misc stuff
# to an already built ISO image via scripting (providing hooks that call
# user-defined scripts).
# squashfs, mkisofs needed

# Define an alternative execution strategy, in this case, the value must be
# "iso_remaster"
execution_strategy: iso_remaster

# Release string
release_string: Sabayon Linux

# File to write release string
release_file: /etc/sabayon-edition

# Release Version
release_version: 6

# Release Version string description
release_desc: x86 Gforensic

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
prechroot: linux32

# Path to source ISO file (MANDATORY)
source_iso: /sabayon/iso/Sabayon_Linux_DAILY_x86_G.iso

# Outer chroot script command, to be executed outside destination chroot before
# before entering it (and before inner_chroot_script)
outer_chroot_script: /sabayon/scripts/remaster_pre.sh

# Inner chroot script command, to be executed inside destination chroot before packing it
# - kmerge.sh - setup kernel bins
#  inner_chroot_script: 

# Execute repositories update here, in a more fault-tolerant flavor
inner_chroot_script: /sabayon/scripts/remaster_generic_inner_chroot_script.sh

# Inner chroot script command, to be executed inside destination chroot after
# packages installation and removal
inner_chroot_script_after: /sabayon/scripts/remaster_generic_inner_chroot_script_after.sh gforensic

# Outer chroot script command, to be executed outside destination chroot before
# before entering it (and AFTER inner_chroot_script)
outer_chroot_script_after: /sabayon/scripts/gforensic_remaster_post.sh

# Used to umount /proc and unbind packages dir
error_script: /sabayon/scripts/remaster_error_script.sh

# Extra mkisofs parameters, perhaps something to include/use your bootloader
extra_mkisofs_parameters: -b isolinux/isolinux.bin -c isolinux/boot.cat

# Pre-ISO building script. Hook to be able to copy kernel images in place, for example
# pre_iso_script: /sabayon/scripts/cdroot.py

# Destination directory for the ISO image path (MANDATORY)
destination_iso_directory: /sabayon/iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: Sabayon_Linux_Gforensic_6_x86.iso

# Output iso image title
iso_title: Sabayon_Linux_Forensic_x86_G

# Alternative ISO file mount command (default is: mount -o loop -t iso9660)
# iso_mounter:

# Alternative ISO umounter command (default is: umount)
# iso_umounter:

# Alternative squashfs file mount command (default is: mount -o loop -t squashfs)
# squash_mounter:

# Alternative ISO squashfs umount command (default is: umount)
# squash_umounter:

# Merge directory with destination LiveCD root
# merge_livecd_root: /put/more/files/onto/CD/root

# List of packages that would be removed from chrooted system (comma separated)
# List of packages that would be removed from chrooted system (comma separated)
packages_to_remove: net-dialup/pptpclient, net-dialup/gnome-ppp, net-dialup/globespan-adsl, net-dialup/wvdial, app-office/libreoffice-l10n-de, app-office/libreoffice-l10n-es, app-office/libreoffice-l10n-fr, app-office/libreoffice-l10n-it, app-office/libreoffice-l10n-nl, app-office/libreoffice-l10n-pt, games-puzzle/world-of-goo-demo, media-tv/xbmc, net-irc/xchat, www-client/firefox, x11-wm/fluxbox, x11-libs/compiz-bcop, x11-plugins/compiz-plugins-extra, x11-plugins/compiz-plugins-main, x11-wm/compiz, x11-wm/emerald, x11-themes/emerald-themes, x11-apps/fusion-icon, app-emulation/virtualbox-guest-additions, x11-drivers/xf86-input-virtualbox, x11-drivers/xf86-video-virtualbox, x11-terms/guake, gnome-extra/gnome-games, media-tv/linuxtv-dvb-headers, media-tv/ivtv-firmware, media-tv/afatech9005-firmware, www-client/lynx, net-p2p/deluge, media-gfx/gimp, app-admin/packagekit-base, app-admin/packagekit-gtk, app-misc/sabayon-music 

# Custom shell call to packages removal (default is: equo remove)
# custom_packages_remove_cmd:

# List of packages that would be added from chrooted system (comma separated)
packages_to_add: sys-apps/mlocate,
	media-fonts/droid, 
	gnome-base/gvfs, 
	app-misc/sabayon-skel, 
	app-misc/screen, 
	app-forensics/cmospwd, 
	app-forensics/rkhunter, 
	app-forensics/sleuthkit, 
	app-antivirus/clamav, 
	app-antivirus/clamtk, 
	app-forensics/autopsy, 
	app-forensics/mac-robber,
	app-forensics/aide, 
	app-forensics/rdd, 
	app-crypt/chntpw, 
	media-video/vlc, 
	x11-wm/awesome, 
	net-libs/libnet, 
	net-libs/netwib, 
	net-analyzer/traceroute, 
	media-gfx/picasa, 
	app-admin/testdisk, 
	app-crypt/fcrackzip, 
	app-crypt/johntheripper, 
	sys-fs/extundelete, 
	app-forensics/magicrescue, 
	app-crypt/ophcrack, 
	app-crypt/ophcrack-tables, 
	net-analyzer/nmap, 
	net-analyzer/netcat6, 
	net-irc/irssi, 
	net-analyzer/wireshark, 
	net-analyzer/tcpdump,
        gnome-extra/nm-applet,
	net-misc/knock

# Custom shell call to packages add (default is: equo install)
# custom_packages_add_cmd:

# Custom command for updating repositories (default is: equo update)
# repositories_update_cmd:

# Determine whether repositories update should be run (if packages_to_add is set)
# (default is: no), values are: yes, no.
execute_repositories_update: no

# Directories to remove completely (comma separated)
# paths_to_remove:

# Directories to empty (comma separated)
# paths_to_empty:

# Build Menu
pre_iso_script: /sabayon/scripts/gforensic_pre_iso_script.sh
