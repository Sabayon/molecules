#!/bin/bash
# example call:
# amd64_x86_pre_iso_script.sh GNOME 64 32 /path/to/Sabayon_Linux_DAILY_x86_G.iso

remaster_type="${1}"
current_arch="${2}"
other_arch="${3}"
other_iso_path="${4}"

/usr/sbin/env-update
. /etc/profile

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

pre_iso_signal_handler() {
	if [ -d "${tmp_dir}" ] && [ -n "${tmp_dir}" ]; then
		umount -f "${tmp_dir}"
		umount -f "${tmp_dir}"
		rmdir "${tmp_dir}"
	fi
}
trap "pre_iso_signal_handler" EXIT SIGINT SIGQUIT SIGILL SIGTERM SIGHUP

if [ ! -f "${other_iso_path}" ]; then
	echo "${other_iso_path} not found"
	exit 1
fi

isolinux_destination="${CDROOT_DIR}/isolinux/txt.cfg"
grub_destination="${CDROOT_DIR}/boot/grub/grub.cfg"
isolinux_source="${SABAYON_MOLECULE_HOME}/remaster/minimal_amd64_x86_isolinux.cfg"
grub_source="${SABAYON_MOLECULE_HOME}/remaster/minimal_amd64_x86_grub.cfg"
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

# setup squashfs loop files
mv "${CDROOT_DIR}/livecd.squashfs" "${CDROOT_DIR}/livecd${current_arch}.squashfs" || exit 1
# mount other iso image and steal livecd.squashfs
tmp_dir=$(mktemp -d --suffix=amd64_x86_pre_iso --tmpdir=/var/tmp 2> /dev/null)
if [ -z "${tmp_dir}" ]; then
	echo "Cannot create temporary directory"
	exit 1
fi
# also rename kernel and initramfs inside the CDROOT dir
mv "${CDROOT_DIR}/boot/sabayon" "${CDROOT_DIR}/boot/sabayon${current_arch}" || exit 1
mv "${CDROOT_DIR}/boot/sabayon.igz" "${CDROOT_DIR}/boot/sabayon${current_arch}.igz" || exit 1

mount -o loop "${other_iso_path}" "${tmp_dir}" || exit 1
other_squashfs_path="${tmp_dir}/livecd.squashfs"
if [ ! -f "${other_squashfs_path}" ]; then
	echo "Cannot find ${other_squashfs_path}"
	exit 1
fi
cp "${other_squashfs_path}" "${CDROOT_DIR}/livecd${other_arch}.squashfs" || exit 1
# copy kernel and initramfs
cp "${tmp_dir}/boot/sabayon" "${CDROOT_DIR}/boot/sabayon${other_arch}" || exit 1
cp "${tmp_dir}/boot/sabayon.igz" "${CDROOT_DIR}/boot/sabayon${other_arch}.igz" || exit 1

# copy back.jpg to proper location
isolinux_img="${SABAYON_MOLECULE_HOME}/remaster/embedded_world/back.jpg"
if [ -f "${isolinux_img}" ]; then
	cp "${isolinux_img}" "${CDROOT_DIR}/isolinux/" || exit 1
fi

# copy ARM images on the ISO
arm_images_dir="${SABAYON_MOLECULE_HOME}/images"
arm_dir="${CDROOT_DIR}/ARM"
mkdir -p "${arm_dir}" || exit 1

beaglebone_image="Sabayon_Linux_9_armv7a_BeagleBone_Base_2GB.img.xz"
beagleboard_xm_image="Sabayon_Linux_9_armv7a_BeagleBoard_xM_4GB.img.xz"
pandaboard_image="Sabayon_Linux_9_armv7a_PandaBoard_4GB.img.xz"

# BeagleBone
arm_card_dir="${arm_dir}/BeagleBone"
arm_card_boot_dir="${SABAYON_MOLECULE_HOME}/boot/arm/beaglebone"
mkdir "${arm_card_dir}" -p || exit 1
cp "${arm_images_dir}/${beaglebone_image}" "${arm_card_dir}"/ || exit 1
cp "${arm_images_dir}/${beaglebone_image}.md5" "${arm_card_dir}"/ || exit 1
cp "${arm_card_boot_dir}/README.txt" "${arm_card_dir}"/ || exit 1

# BeagleBoard xM
arm_card_dir="${arm_dir}/BeagleBoard-xM"
arm_card_boot_dir="${SABAYON_MOLECULE_HOME}/boot/arm/beagleboard-xm"
mkdir "${arm_card_dir}" -p || exit 1
cp "${arm_images_dir}/${beaglebone_image}" "${arm_card_dir}"/ || exit 1
cp "${arm_images_dir}/${beaglebone_image}.md5" "${arm_card_dir}"/ || exit 1
cp "${arm_card_boot_dir}/README.txt" "${arm_card_dir}"/ || exit 1

# PandaBoard
arm_card_dir="${arm_dir}/PandaBoard"
arm_card_boot_dir="${SABAYON_MOLECULE_HOME}/boot/arm/pandaboard"
mkdir "${arm_card_dir}" -p || exit 1
cp "${arm_images_dir}/${beaglebone_image}" "${arm_card_dir}"/ || exit 1
cp "${arm_images_dir}/${beaglebone_image}.md5" "${arm_card_dir}"/ || exit 1
cp "${arm_card_boot_dir}/README.txt" "${arm_card_dir}"/ || exit 1

# Generate livecd.squashfs.md5
"${SABAYON_MOLECULE_HOME}"/scripts/pre_iso_script_livecd_hash.sh
