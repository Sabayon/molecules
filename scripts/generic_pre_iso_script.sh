#!/bin/bash

/usr/sbin/env-update
. /etc/profile

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

remaster_type="${1}"
isolinux_source="${SABAYON_MOLECULE_HOME}/remaster/minimal_isolinux.cfg"
grub_source="${SABAYON_MOLECULE_HOME}/remaster/minimal_grub.cfg"
isolinux_destination="${CDROOT_DIR}/isolinux/txt.cfg"
grub_destination="${CDROOT_DIR}/boot/grub/grub.cfg"

if [ "${remaster_type}" = "KDE" ] || [ "${remaster_type}" = "GNOME" ]; then
	isolinux_source="${SABAYON_MOLECULE_HOME}/remaster/standard_isolinux.cfg"
	grub_source="${SABAYON_MOLECULE_HOME}/remaster/standard_grub.cfg"
elif [ "${remaster_type}" = "ServerBase" ]; then
	echo "ServerBase trigger, copying server kernel over"
	boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
	boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
	cp "${boot_kernel}" "${CDROOT_DIR}/boot/sabayon" || exit 1
	cp "${boot_ramfs}" "${CDROOT_DIR}/boot/sabayon.igz" || exit 1
	isolinux_source="${SABAYON_MOLECULE_HOME}/remaster/serverbase_isolinux.cfg"
	grub_source="${SABAYON_MOLECULE_HOME}/remaster/serverbase_grub.cfg"
elif [ "${remaster_type}" = "HardenedServer" ]; then
	echo "HardenedServer trigger, copying server kernel over"
	boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
	boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
	cp "${boot_kernel}" "${CDROOT_DIR}/boot/sabayon" || exit 1
	cp "${boot_ramfs}" "${CDROOT_DIR}/boot/sabayon.igz" || exit 1
	isolinux_source="${SABAYON_MOLECULE_HOME}/remaster/hardenedserver_isolinux.cfg"
	grub_source="${SABAYON_MOLECULE_HOME}/remaster/hardenedserver_grub.cfg"
fi
cp "${isolinux_source}" "${isolinux_destination}" || exit 1
cp "${grub_source}" "${grub_destination}" || exit 1

# Generate Language and Keyboard menus for GRUB-2
"${SABAYON_MOLECULE_HOME}"/scripts/make_grub_langs.sh "${grub_destination}" \
	|| exit 1

# generate EFI GRUB
"${SABAYON_MOLECULE_HOME}"/scripts/make_grub_efi.sh || exit 1

ver=${RELEASE_VERSION}
[[ -z "${ver}" ]] && ver=${CUR_DATE}
[[ -z "${ver}" ]] && ver="6"

sed -i "s/__VERSION__/${ver}/g" "${isolinux_destination}" || exit 1
sed -i "s/__FLAVOUR__/${remaster_type}/g" "${isolinux_destination}" || exit 1
sed -i "s/__VERSION__/${ver}/g" "${grub_destination}" || exit 1
sed -i "s/__FLAVOUR__/${remaster_type}/g" "${grub_destination}" || exit 1

kms_string=""
# should KMS be enabled?
if [ -f "${CHROOT_DIR}/.enable_kms" ]; then
	rm "${CHROOT_DIR}/.enable_kms"
	kms_string="radeon.modeset=1"
else
	# enable vesafb-tng then
	kms_string="video=vesafb:ywrap,mtrr:3"
fi
sed -i "s/__KMS__/${kms_string}/g" "${isolinux_destination}" || exit 1
sed -i "s/__KMS__/${kms_string}/g" "${grub_destination}" || exit 1

sabayon_pkgs_file="${CHROOT_DIR}/etc/sabayon-pkglist"
if [ -f "${sabayon_pkgs_file}" ]; then
	cp "${sabayon_pkgs_file}" "${CDROOT_DIR}/pkglist"
	if [ -n "${ISO_PATH}" ]; then # molecule 0.9.6 required
		# copy pkglist over to ISO path + pkglist
		cp "${sabayon_pkgs_file}" "${ISO_PATH}".pkglist
	fi
fi

# copy back.jpg to proper location
isolinux_img="${CHROOT_DIR}/usr/share/backgrounds/isolinux/back.jpg"
if [ -f "${isolinux_img}" ]; then
	cp "${isolinux_img}" "${CDROOT_DIR}/isolinux/" || exit 1
fi

# Generate livecd.squashfs.md5
"${SABAYON_MOLECULE_HOME}"/scripts/pre_iso_script_livecd_hash.sh
