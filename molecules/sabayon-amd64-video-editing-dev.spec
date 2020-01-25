# Use abs path, otherwise daily builds automagic won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/gnome.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/video-editing.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/amd64.common

# Pre-ISO building script. Hook to be able to copy kernel images in place,
# for example.
# NOTE: Not inserted on gnome.common to fix use of forensics pre_iso_script.
%env pre_iso_script: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/generic_pre_iso_script.sh VideoEditing

# Release Version
%env release_version: ${SABAYON_RELEASE:-LATEST}

# Release Version string description
release_desc: amd64 VideoEditing Development

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/${SABAYON_SOURCE_ISO_DEV}

destination_iso_image_name: Sabayon_Linux_DAILY_amd64_VideoEditing-dev.iso
