#!/bin/bash
# Expected env variables:
# CHROOT_DIR
# CDROOT_DIR

# This scripts generates an EFI-enabled boot structure

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

MOUNT_DIRS=()
EFI_BOOT_DIR="${CDROOT_DIR}/efi/boot"
GRUB_BOOT_DIR_PREFIX="/boot/grub"
GRUB_LOCALE_DIR_PREFIX="${GRUB_BOOT_DIR_PREFIX}/locale"
GRUB_BOOT_DIR="${CDROOT_DIR}${GRUB_BOOT_DIR_PREFIX}"
GRUB_LOCALE_DIR="${CDROOT_DIR}${GRUB_LOCALE_DIR_PREFIX}"
mkdir -p "${EFI_BOOT_DIR}" || exit 1
mkdir -p "${GRUB_BOOT_DIR}" || exit 1
mkdir -p "${GRUB_LOCALE_DIR}" || exit 1

x86_64_EFI_DIR_PREFIX="/usr/lib/grub/x86_64-efi"
i386_EFI_DIR_PREFIX="/usr/lib/grub/i386-efi"
x86_64_EFI_DIR="${CHROOT_DIR}${x86_64_EFI_DIR_PREFIX}"
i386_EFI_DIR="${CHROOT_DIR}${i386_EFI_DIR_PREFIX}"

pre_iso_signal_handler() {
	for mount_dir in "${MOUNT_DIRS[@]}"; do
		if [ -d "${mount_dir}" ]; then
			umount -f "${mount_dir}" || \
				umount -l "${mount_dir}" # best effort
			rmdir "${mount_dir}"
		fi
	done
}
trap "pre_iso_signal_handler" EXIT SIGINT SIGQUIT SIGILL SIGTERM SIGHUP

if [ -d "${x86_64_EFI_DIR}" ]; then
	# create the EFI image
	chroot "${CHROOT_DIR}" grub2-mkimage \
		-p "${GRUB_BOOT_DIR_PREFIX}" \
		-d "${x86_64_EFI_DIR_PREFIX}" \
		-o /bootx64.efi \
		-O x86_64-efi ext2 fat lvm part_msdos \
			part_gpt hfsplus bsd search_fs_uuid normal \
			chain iso9660 configfile loadenv \
			reboot cat \
		|| exit 1
	mv "${CHROOT_DIR}"/bootx64.efi "${EFI_BOOT_DIR}/" || exit 1
	cp -Rp "${x86_64_EFI_DIR}" "${GRUB_BOOT_DIR}/" || exit 1
fi
if [ -d "${i386_EFI_DIR}" ]; then
	# create the EFI image
	chroot "${CHROOT_DIR}" grub2-mkimage \
		-p "${GRUB_BOOT_DIR_PREFIX}" \
		-d "${i386_EFI_DIR_PREFIX}" \
		-o /boota32.efi \
		-O i386-efi ext2 fat lvm part_msdos \
			part_gpt hfsplus bsd search_fs_uuid normal \
			chain iso9660 configfile loadenv \
			reboot cat \
		|| exit 1
	mv "${CHROOT_DIR}"/boota32.efi "${EFI_BOOT_DIR}/" || exit 1
	cp -Rp "${i386_EFI_DIR}" "${GRUB_BOOT_DIR}/" || exit 1
fi

# These must exist.
cp "${CHROOT_DIR}/usr/share/grub/unicode.pf2" "${GRUB_BOOT_DIR}"/ || exit 1

# Copy locale files
localedir="${CHROOT_DIR}/usr/share/locale"
for dir in "${localedir}"/*; do
	if [ -f "${dir}/LC_MESSAGES/grub.mo" ]; then
		cp -f "${dir}/LC_MESSAGES/grub.mo" "${GRUB_LOCALE_DIR}/${dir##*/}.mo"
	fi
done

# Copy splash, this is in sabayon-artwork-grub, we expect to find it
cp "${CHROOT_DIR}/usr/share/grub/default-splash.png" "${GRUB_BOOT_DIR}"/ \
	|| exit 1

# now setup SecureBoot for x86_64 using shim:
# See: http://mjg59.dreamwidth.org/20303.html
efi_x86_64_file="${EFI_BOOT_DIR}"/bootx64.efi
efi_i386_file="${EFI_BOOT_DIR}"/boota32.efi
grub_efi_file="${EFI_BOOT_DIR}"/grubx64.efi
efi_img="${GRUB_BOOT_DIR}"/efi.img
shim_dir="${SABAYON_MOLECULE_HOME}"/boot/shim-uefi-secure-boot
shim_data_dir="${CHROOT_DIR}/usr/share/shim-signed-0.2"
# This is on the ISO build server, not on the repos
sbsign_private_key="${shim_dir}"/private.key
# actually, UEFI SecureBoot needs the cert in DER
# format (sabayon.cer), while sbsign requires a
# plain old text-based x509 certificate (sabayon.crt)
sabayon_der="${shim_dir}"/sabayon.cer
sabayon_cert="${shim_dir}"/sabayon.crt

if [ -f "${efi_x86_64_file}" ] || [ -f "${efi_i386_file}" ]; then

	if [ -f "${efi_x86_64_file}" ]; then
		mv "${efi_x86_64_file}" "${grub_efi_file}" || exit 1
		cp "${shim_data_dir}"/shim.efi "${efi_x86_64_file}" || exit 1
		cp "${shim_data_dir}"/MokManager.efi "${EFI_BOOT_DIR}"/ || exit 1

		# Copy the Sabayon SecureBoot certificate to a nice dir
		mkdir -p "${CDROOT_DIR}"/SecureBoot || exit 1
		cp "${sabayon_der}" "${CDROOT_DIR}"/SecureBoot/ || exit 1

		# Sign
		sbsign --key "${sbsign_private_key}" --cert "${sabayon_cert}" \
			--output "${grub_efi_file}.signed" \
			"${grub_efi_file}" || exit 1
		mv "${grub_efi_file}.signed" "${grub_efi_file}" || exit 1
	fi

	# -- end of SecureBoot --
	# UEFI is currently only supported in x86_64

	# now the tricky part, create an eltorito alternative image
	# 12 floppies = 2880 x 12, we need more space for SecureBoot and GRUB2
	# stuff to make isohybrid work as expected.
	dd bs=512 count=$((2880 * 12)) if=/dev/zero of="${efi_img}" || exit 1
	mkfs.msdos "${efi_img}" || exit 1

	tmp_dir=$(mktemp -d --suffix="make_grub_efi")
	[[ -z "${tmp_dir}" ]] && exit 1
	MOUNT_DIRS+=( "${tmp_dir}" )
	mount -o loop "${efi_img}" "${tmp_dir}" || exit 1
	mkdir -p "${tmp_dir}/efi/boot" || exit 1

	# copy our .efi executables in place
	cp -Rp "${EFI_BOOT_DIR}"/* "${tmp_dir}/efi/boot/" || exit 1

	# in order to make isohybrid work, we need to copy the grub
	# stuff inside the EFI boot image
	tmp_grub_dir="${tmp_dir}/boot/grub"
	mkdir -p "${tmp_grub_dir}" || exit 1

	# This file is used by grub to determine where's the cdroot
	ts=$(date +%Y%m%d%H%M%S)
	img_id="${ts}${RANDOM}"
	id_file="id.${img_id}.uefi"
	touch "${CDROOT_DIR}/${id_file}" || exit 1

	# copy the chainload grub.cfg version
	cp "${SABAYON_MOLECULE_HOME}/boot/core/grub/grub-uefi-isohybrid.cfg" \
		"${tmp_grub_dir}/grub.cfg" || exit 1
	sed -i "s:%id_file%:${id_file}:g" "${tmp_grub_dir}/grub.cfg" || exit 1

	# copy modules, actually, we would just need search
	cp -R "${GRUB_BOOT_DIR}/"*-efi "${tmp_grub_dir}/" || exit 1
	mkdir -p "${tmp_grub_dir}/SecureBoot" || exit 1
	cp "${sabayon_der}" "${tmp_grub_dir}/SecureBoot/" || exit 1

	umount "${tmp_dir}" || exit 1
	rmdir "${tmp_dir}" # best effort
	exit 0
else
	# images not supporting UEFI must get a fake file as efi.img
	# because our mkisofs parameters are static.
	dd bs=512 count=$((2880 * 1)) if=/dev/zero of="${efi_img}" || exit 1
	mkfs.msdos "${efi_img}" || exit 1
fi
