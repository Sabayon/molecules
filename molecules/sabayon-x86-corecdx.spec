# use abs path, otherwise daily iso build automagic won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/corecdx.common

release_version: 9
release_desc: x86 CoreCDX

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
prechroot: linux32

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_SpinBase_DAILY_x86.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: Sabayon_Linux_CoreCDX_9_x86.iso
