# Use abs path, otherwise daily builds automagic won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/enlightenment.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/amd64.common

# Release Version
%env release_version: ${SABAYON_RELEASE:-LATEST}

# Release Version string description
release_desc: amd64 Enlightenment

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/${SABAYON_SOURCE_ISO}

# Destination ISO image name, call whatever you want.iso, not mandatory
%env destination_iso_image_name: Sabayon_Linux_${SABAYON_RELEASE:-LATEST}_amd64_Enlightenment.iso
