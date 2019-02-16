# Use abs path, otherwise daily builds automagic won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/gnome.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/amd64.common

# Pre-ISO building script. Hook to be able to copy kernel images in place,
# for example.
# NOTE: Not inserted on gnome.common to fix use of forensics pre_iso_script.
%env pre_iso_script: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/generic_pre_iso_script.sh GNOME

%env release_version: ${SABAYON_RELEASE:-LATEST}
release_desc: amd64 GNOME

%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/${SABAYON_SOURCE_ISO}
%env destination_iso_image_name: Sabayon_Linux_${SABAYON_RELEASE:-LATEST}_amd64_GNOME.iso
