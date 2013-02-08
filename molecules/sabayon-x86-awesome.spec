# Use abs path, otherwise daily iso build won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/awesome.common

prechroot: linux32

# Release Version
release_version: 10

# Release Version string description
release_desc: x86 Awesome

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_SpinBase_DAILY_x86.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: Sabayon_Linux_11_x86_Awesome.iso
