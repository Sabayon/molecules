#!/bin/bash

/usr/sbin/env-update
. /etc/profile

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

boot_dir="${CHROOT_DIR}/boot"
cdroot_boot_dir="${CDROOT_DIR}/boot"

kernels=( "${boot_dir}"/kernel-* )
# get the first one and see if it exists
kernel="${kernels[0]}"
if [ ! -f "${kernel}" ]; then
	echo "No kernels in ${boot_dir}" >&2
	exit 1
fi

initramfss=( "${boot_dir}"/initramfs-* )
# get the first one and see if it exists
initramfs="${initramfss[0]}"
if [ ! -f "${initramfs}" ]; then
	echo "No initramfs in ${boot_dir}" >&2
	exit 1
fi

# copy kernel and initramfs
cp "${kernel}" "${cdroot_boot_dir}"/sabayon || exit 1
cp "${initramfs}" "${cdroot_boot_dir}"/sabayon.igz || exit 1

# Write build info
build_date=$(date)
build_file="${CDROOT_DIR}"/BUILD_INFO
echo "Sabayon ISO image build information" > "${build_file}" || exit 1
echo "Built on: ${build_date}" >> "${build_file}" || exit 1

ver=${RELEASE_VERSION}
[[ -z "${ver}" ]] && ver=${CUR_DATE}
[[ -z "${ver}" ]] && ver="6"

isolinux_dest="${CDROOT_DIR}/isolinux/txt.cfg"
isolinux_dest_txt="${CDROOT_DIR}/isolinux/isolinux.txt"
grub_dest="${CDROOT_DIR}/boot/grub/grub.cfg"

for path in "${isolinux_dest}" "${isolinux_dest_txt}" "${grub_dest}"; do
	sed -i "s/__VERSION__/${ver}/g" "${path}" || exit 1
	sed -i "s/__FLAVOUR__/${remaster_type}/g" "${path}" || exit 1
done

# Generate Language and Keyboard menus for GRUB-2
"${SABAYON_MOLECULE_HOME}"/scripts/make_grub_langs.sh "${grub_dest}" \
	|| exit 1

# generate EFI GRUB
"${SABAYON_MOLECULE_HOME}"/scripts/make_grub_efi.sh || exit 1

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
