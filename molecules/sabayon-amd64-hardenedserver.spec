# Use abs path, otherwise daily iso build won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/hardenedserver.common

release_version: 10
release_desc: amd64 Hardened Server

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_SpinBase_DAILY_amd64.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: Sabayon_Linux_HardenedServer_10_amd64.iso
