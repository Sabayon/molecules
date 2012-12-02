#!/bin/bash
# Expected env variables:
# CHROOT_DIR
# CDROOT_DIR

# This scripts generates an EFI-enabled boot structure

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
		-O x86_64-efi ext2 fat lvm part_msdos part_gpt search_fs_uuid normal chain iso9660 \
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
		-O i386-efi ext2 fat lvm part_msdos part_gpt search_fs_uuid normal chain iso9660 \
		|| exit 1
	mv "${CHROOT_DIR}"/boota32.efi "${EFI_BOOT_DIR}/" || exit 1
	cp -Rp "${i386_EFI_DIR}" "${GRUB_BOOT_DIR}/" || exit 1
fi

# now the tricky part, create an eltorito alternative image
_efi_img="${GRUB_BOOT_DIR}"/efi.img
dd bs=512 count=2880 if=/dev/zero of="${_efi_img}" || exit 1
mkfs.msdos "${_efi_img}" || exit 1

tmp_dir=$(mktemp -d --suffix="make_grub_efi")
[[ -z "${tmp_dir}" ]] && exit 1
MOUNT_DIRS+=( "${tmp_dir}" )
mount -o loop "${_efi_img}" "${tmp_dir}" || exit 1
mkdir -p "${tmp_dir}/efi/boot" || exit 1

_efi_boot="${EFI_BOOT_DIR}"/bootx64.efi
cp "${_efi_boot}" "${tmp_dir}/efi/boot"/ || exit 1
umount "${tmp_dir}" || exit 1

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
