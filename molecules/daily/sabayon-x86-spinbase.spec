# Use abs path, otherwise daily builds automagic won't work
%import /sabayon/molecules/spinbase.common

# 32bit build
prechroot: linux32

# Release Version
# Keep this here, otherwise daily builds automagic won't work
release_version: 20100917

# Release Version string description
release_desc: x86 SpinBase

# Source chroot directory, where files are pulled from
source_chroot: /sabayon/sources/x86_core-2010

# Destination ISO image name, call whatever you want.iso, not mandatory
# Keep this here and set, otherwise daily builds automagic won't work
destination_iso_image_name: Sabayon_Linux_SpinBase_DAILY_x86.iso

inner_source_chroot_script: /sabayon/scripts/inner_source_chroot_update.sh
