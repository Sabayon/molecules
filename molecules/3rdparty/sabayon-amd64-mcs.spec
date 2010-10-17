# Use abs path, otherwise daily builds automagic won't work

# Release Version
release_version: 1.0

# Release Version string description
release_desc: amd64 MCS

# Path to source ISO file
source_iso: /media/ae5ebf25-75e3-4c00-abaa-036aacf2a5f5/sabayon/iso/Sabayon_Linux_5.4_amd64_G.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: Sabayon_Linux_5.4_amd64_MCS.iso

# Define an alternative execution strategy, in this case, the value must be
# "iso_remaster"
execution_strategy: iso_remaster

# Release string
release_string: Sabayon Linux

# File to write release string
release_file: /etc/sabayon-edition

# ISO Image title
iso_title: Sabayon MCS

# Outer chroot script command, to be executed outside destination chroot before
# before entering it (and before inner_chroot_script)
outer_chroot_script: /sabayon/scripts/3rdparty/remaster_mcs_pre.sh

# Execute repositories update here, in a more fault-tolerant flavor
inner_chroot_script: /sabayon/scripts/3rdparty/remaster_mcs_inner_chroot_script.sh

# Inner chroot script command, to be executed inside destination chroot after
# packages installation and removal
inner_chroot_script_after: /sabayon/scripts/3rdparty/remaster_mcs_inner_chroot_script_after.sh

# Outer chroot script command, to be executed outside destination chroot before
# before entering it (and AFTER inner_chroot_script)
outer_chroot_script_after: /sabayon/scripts/remaster_post.sh

# Extra mkisofs parameters, perhaps something to include/use your bootloader
extra_mkisofs_parameters: -b isolinux/isolinux.bin -c isolinux/boot.cat

# Pre-ISO building script. Hook to be able to copy kernel images in place, for example
pre_iso_script: /sabayon/scripts/generic_pre_iso_script.sh MCS

# Destination directory for the ISO image path (MANDATORY)
destination_iso_directory: /sabayon/iso

# List of packages that would be removed from chrooted system (comma separated)
packages_to_remove: app-office/openoffice, app-emulation/wine, sabayon-mce, sabayon-music, sun-jre-bin

# List of packages that would be added from chrooted system (comma separated)
packages_to_add:
	net-nds/389-ds-base,
	app-admin/389-ds-console,
	app-admin/389-admin-console,
	app-admin/389-console,
	net-nds/389-admin,
	net-mail/dovecot,
	mail-mta/postfix,
	net-mail/cyrus-imapd,
	www-servers/apache[threads],
	www-servers/jboss-bin:4.2,
	net-mail/gnarwl,
	rpm2targz,
	nmap,
	tcpdump

# Custom shell call to packages add (default is: equo install)
custom_packages_add_cmd: equo install --relaxed

# Custom command for updating repositories (default is: equo update)
# repositories_update_cmd:

# Determine whether repositories update should be run (if packages_to_add is set)
# (default is: no), values are: yes, no.
execute_repositories_update: no

# Directories to remove completely (comma separated)
# paths_to_remove:

# Directories to empty (comma separated)
# paths_to_empty:
