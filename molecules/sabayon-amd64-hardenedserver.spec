# Use abs path, otherwise daily iso build won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/hardenedserver.common

%env release_version: ${SABAYON_RELEASE:-11}
release_desc: amd64 Hardened Server

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_${ISO_TAG:-DAILY}_amd64_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
%env destination_iso_image_name: Sabayon_Linux_${SABAYON_RELEASE:-11}_amd64_HardenedServer.iso
