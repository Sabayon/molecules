# Use abs path, otherwise daily builds automagic won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/gnome.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/forensic.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/amd64.common

# Release Version
%env release_version: ${SABAYON_RELEASE:-LATEST}

# Release Version string description
release_desc: amd64 ForensicsGnome

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/${SABAYON_SOURCE_ISO}

destination_iso_image_name: Sabayon_Linux_DAILY_amd64_ForensicsGnome.iso
