# Use abs path, otherwise daily builds automagic won't work
# For further documentation, see the file above:
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/spinbase-amazon-ami-image-template.common

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
prechroot: linux32

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_SpinBase_DAILY_x86.iso

release_version: 10
image_name: Sabayon_Linux_SpinBase_10_x86_ami.img
