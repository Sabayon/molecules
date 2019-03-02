# Use abs path, otherwise daily builds automagic won't work
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/spinbase-tarball-template.common

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
# prechroot:

# Path to source ISO file (MANDATORY)
%env source_iso: ${SABAYON_MOLECULE_HOME:-/sabayon}/iso/${SABAYON_SOURCE_ISO}

%env release_version: ${SABAYON_RELEASE:-LATEST}
%env tar_name: Sabayon_Linux_${SABAYON_RELEASE:-LATEST}_amd64_SpinBase_tarball.tar.gz
