# Use abs path, otherwise daily builds automagic won't work
%import /sabayon/molecules/spinbase-openvz-template.common

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
# prechroot:

# Path to source ISO file (MANDATORY)
source_iso: /sabayon/iso/Sabayon_Linux_SpinBase_DAILY_amd64.iso

release_version: 8
tar_name: Sabayon_Linux_SpinBase_8_amd64_openvz.tar.gz
