# Use abs path, otherwise daily builds automagic won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/spinbase.common

# Release Version
# Keep this here, otherwise daily builds automagic won't work
%env release_version: ${SABAYON_RELEASE:-11}

# Release Version string description
release_desc: amd64 SpinBase

# Source chroot directory, where files are pulled from
%env source_chroot: ${SABAYON_MOLECULE_HOME:-/sabayon}/sources/amd64_core-2010

# Destination ISO image name, call whatever you want.iso, not mandatory
# Keep this here and set, otherwise daily builds automagic won't work
%env destination_iso_image_name: Sabayon_Linux_${SABAYON_RELEASE:-11}_amd64_SpinBase.iso
