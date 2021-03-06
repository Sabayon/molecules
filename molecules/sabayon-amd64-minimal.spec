# Use abs path, otherwise daily iso build won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/minimal.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/amd64.common

%env release_version: ${SABAYON_RELEASE:-LATEST}
release_desc: amd64 Minimal

%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/${SABAYON_SOURCE_ISO}
%env destination_iso_image_name: Sabayon_Linux_${SABAYON_RELEASE:-LATEST}_amd64_Minimal.iso
