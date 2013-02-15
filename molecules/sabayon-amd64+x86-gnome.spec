# Define an alternative execution strategy, in this case, the value must be
# "iso_remaster"
execution_strategy: iso_remaster

# Release string
release_string: Sabayon Linux

# File to write release string
release_file: /etc/sabayon-edition

# ISO Image title
iso_title: Sabayon GNOME

# Outer chroot script command, to be executed outside destination chroot before
# before entering it (and before inner_chroot_script)
# outer_chroot_script: 

# Execute repositories update here, in a more fault-tolerant flavor
# inner_chroot_script: 

# Inner chroot script command, to be executed inside destination chroot after
# packages installation and removal
%env inner_chroot_script_after: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/amd64_x86_inner_chroot_script_after.sh

# Outer chroot script command, to be executed outside destination chroot before
# before entering it (and AFTER inner_chroot_script)
# outer_chroot_script_after:

# Used to umount /proc and unbind packages dir
%env error_script: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/remaster_error_script.sh

# Extra mkisofs parameters, perhaps something to include/use your bootloader
extra_mkisofs_parameters: -b isolinux/isolinux.bin -c isolinux/boot.cat -eltorito-alt-boot -no-emul-boot -eltorito-platform efi -eltorito-boot boot/grub/efi.img

# Pre-ISO building script. Hook to be able to copy kernel images in place, for example
%env pre_iso_script: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/amd64_x86_pre_iso_script.sh GNOME 64 32 ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_${SABAYON_RELEASE:-11}_x86_GNOME.iso

# Post-ISO building script, called after ISO image generation.    
%env post_iso_script: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/generic_post_iso_script.sh

# Destination directory for the ISO image path (MANDATORY)
%env destination_iso_directory: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso

# List of packages that would be removed from chrooted system (comma separated)
# packages_to_remove:

# List of packages that would be added from chrooted system (comma separated)
# packages_to_add:

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

# Release Version
%env release_version: ${SABAYON_RELEASE:-11}

# Release Version string description
release_desc: amd64+x86 GNOME

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_${SABAYON_RELEASE:-11}_amd64_GNOME.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
%env destination_iso_image_name: Sabayon_Linux_${SABAYON_RELEASE:-11}_amd64+x86_GNOME.iso
