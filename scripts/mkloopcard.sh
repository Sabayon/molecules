#! /bin/sh
# (c) Copyright 2012 Fabio Erculiani <lxnay@sabayon.org>
# Licensed under terms of GPLv2

env-update
. /etc/profile

export LC_ALL=en_US.UTF-8

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

# Expected env variables:
# PATHS_TO_REMOVE = ";" separated list of paths to rm -rf
# PATHS_TO_EMPTY = ";" separated list of paths to rm -rf (keeping the dir)
# RELEASE_STRING
# RELEASE_VERSION
# RELEASE_DESC
# RELEASE_FILE
# IMAGE_NAME
# DESTINATION_IMAGE_DIR
# PACKAGES_TO_ADD
# PACKAGES_TO_REMOVE

if [ ${#} -ne 5 ]; then
	echo "usage: ${0} <path to regular file containing the image> <size in Mb> <source boot files dir> <source chroot>"
	exit 1
fi

CHROOT_SCRIPT="${1}"
if [ ! -x "${CHROOT_SCRIPT}" ]; then
	echo "${CHROOT_SCRIPT} is not executable"
	exit 1
fi
FILE="${2}"
SIZE="${3}"
BOOT_DIR="${4}"
CHROOT_DIR="${5}"
# Should we make a tarball of the rootfs and bootfs?
MAKE_TARBALL="${MAKE_TARBALL:-1}"
# Boot partition type
BOOT_PART_TYPE="${BOOT_PART_TYPE:-vfat}"
BOOT_PART_TYPE_MBR="${BOOT_PART_TYPE_MBR:-0x0C}"
BOOT_PART_MKFS_ARGS="${BOOT_PART_MKFS_ARGS:--n boot -F 32}"
# Root partition type
ROOT_PART_TYPE="${ROOT_PART_TYPE:-ext3}"
ROOT_PART_MKFS_ARGS="${ROOT_PART_MKFS_ARGS:--L Sabayon}"
# Copy /boot content from Root partition to Boot partition?
BOOT_PART_TYPE_INSIDE_ROOT="${BOOT_PART_TYPE_INSIDE_ROOT:-}"

cleanup_loopbacks() {
	cd /
	sync
	sync
	sleep 5
	sync
	[[ -n "${tmp_file}" ]] && rm "${tmp_file}" 2> /dev/null
	[[ -n "${tmp_dir}" ]] && { umount "${tmp_dir}/proc" &> /dev/null; }
	[[ -n "${tmp_dir}" ]] && { umount "${tmp_dir}" &> /dev/null; rmdir "${tmp_dir}" &> /dev/null; }
	[[ -n "${boot_tmp_dir}" ]] && { umount "${boot_tmp_dir}" &> /dev/null; rmdir "${boot_tmp_dir}" &> /dev/null; }
	sleep 1
	[[ -n "${boot_part}" ]] && losetup -d "${boot_part}" 2> /dev/null
	[[ -n "${root_part}" ]] && losetup -d "${root_part}" 2> /dev/null
	[[ -n "${DRIVE}" ]] && losetup -d "${DRIVE}" 2> /dev/null
	# make sure to have run this
	[[ -n "${tmp_dir}" ]] && CHROOT_DIR="${tmp_dir}" "${SABAYON_MOLECULE_HOME}"/scripts/mmc_remaster_post.sh
}
trap "cleanup_loopbacks" 1 2 3 6 9 14 15 EXIT

# Erase the file
echo "Generating the empty image file at ${FILE}"
dd if=/dev/zero of="${FILE}" bs=1024000 count="${SIZE}"
[[ "$?" != "0" ]] && exit 1

DRIVE=$(losetup -f "${FILE}" --show)
if [ -z "${DRIVE}" ]; then
	echo "Cannot execute losetup for $FILE"
	exit 1
fi

echo "Configured the loopback partition at ${DRIVE}"

# Calculate size using fdisk
SIZE=$(fdisk -l "${DRIVE}" | grep Disk | grep bytes | awk '{print $5}')
CYLINDERS=$((SIZE/255/63/512))
# Magic first partition size, given 9 cylinders below
MAGICSIZE="73995264"
STARTOFFSET="32256"

echo "Disk size    : ${SIZE} bytes"
echo "Disk cyls    : ${CYLINDERS}"
echo "Magic size   : ${MAGICSIZE} bytes (boot part size)"
echo "Start offset : ${STARTOFFSET} bytes"

# this will create a first partition that is 73995264 bytes long
# Starts at sect 63, ends at sect 144584, each sector is 512bytes
# In fact it creates 9 cyls
{
echo ,9,${BOOT_PART_TYPE_MBR},*
echo ,,,-
} | sfdisk -D -H 255 -S 63 -C ${CYLINDERS} ${DRIVE}

sleep 2

# The second partiton will start at block 144585, get the end block
ENDBLOCK=$(fdisk -l "${DRIVE}" | grep "${DRIVE}p2" | awk '{print $3}')
EXTSIZE=$(((ENDBLOCK - 144585) * 512))
# Get other two loopback devices first
EXTOFFSET=$((STARTOFFSET + MAGICSIZE))

echo "ExtFS size   : ${EXTSIZE} bytes"
echo "ExtFS offset : ${EXTOFFSET} bytes"

# Get other two loopback devices first
boot_part=$(losetup -f --offset "${STARTOFFSET}" --sizelimit "${MAGICSIZE}" "${FILE}" --show)
if [ -z "${boot_part}" ]; then
	echo "Cannot setup the boot partition loopback"
	exit 1
fi


root_part=$(losetup -f --offset "${EXTOFFSET}" --sizelimit "${EXTSIZE}" "${FILE}" --show)
if [ -z "${root_part}" ]; then
	echo "Cannot setup the ${ROOT_PART_TYPE} partition loopback"
	exit 1
fi

echo "Boot Partiton at   : ${boot_part}"
echo "Root Partition at : ${root_part}"

# Format boot
echo "Formatting ${BOOT_PART_TYPE} ${boot_part}..."
"mkfs.${BOOT_PART_TYPE}" ${BOOT_PART_MKFS_ARGS} "${boot_part}" || exit 1

# Format extfs
echo "Formatting ${ROOT_PART_TYPE} ${root_part}..."
"mkfs.${ROOT_PART_TYPE}" ${ROOT_PART_MKFS_ARGS} "${root_part}" || exit 1

boot_tmp_dir=$(mktemp -d)
if [[ -z "${boot_tmp_dir}" ]]; then
	echo "Cannot create temporary dir (boot)"
	exit 1
fi
chmod 755 "${boot_tmp_dir}" || exit 1

tmp_dir=$(mktemp -d)
if [[ -z "${tmp_dir}" ]]; then
	echo "Cannot create temporary dir"
	exit 1
fi
chmod 755 "${tmp_dir}" || exit 1

sleep 2
sync

echo "Setting up the boot directory content, mounting on ${boot_tmp_dir}"
mount "${boot_part}" "${boot_tmp_dir}"
cp -R "${BOOT_DIR}"/* "${boot_tmp_dir}"/ || exit 1

echo "Setting up the extfs directory content, mounting on ${tmp_dir}"
mount "${root_part}" "${tmp_dir}"
rsync -a -H -A -X --delete-during "${CHROOT_DIR}"/ "${tmp_dir}"/ --exclude "/proc/*" --exclude "/sys/*" \
	--exclude "/dev/pts/*" --exclude "/dev/shm/*" || exit 1

CHROOT_DIR="${tmp_dir}" "${SABAYON_MOLECULE_HOME}"/scripts/remaster_pre.sh || exit 1

# Configure 00-board-setup.start
source_board_setup="${SABAYON_MOLECULE_HOME}/boot/arm_startup/00-board-setup.start"
dest_board_setup="${CHROOT_DIR}/etc/local.d/00-board-setup.start"
if [ -f "${source_board_setup}" ]; then
	echo "Setting up ${dest_board_setup}"
	cp "${source_board_setup}" "${dest_board_setup}" || exit 1
	chmod 755 "${dest_board_setup}" || exit 1
	chown root:root "${dest_board_setup}" || exit 1
fi

# execute PACKAGES_TO_ADD and PACKAGES_TO_REMOVE
export ETP_NONINTERACTIVE=1
# Entropy doesn't like non-UTF locale encodings
export LC_ALL=en_US.UTF-8

# do I have to run "equo update?"
# If we are running outside the DAILY scope, it's
# better to do it here. If instead we're doing a
# DAILY, this is already done by other scripts.
if [ -z "$(basename ${IMAGE_NAME} | grep DAILY)" ]; then
	FORCE_EAPI=2 chroot "${tmp_dir}" equo update || \
	FORCE_EAPI=2 chroot "${tmp_dir}" equo update || \
		exit 1
fi

if [ -n "${PACKAGES_TO_ADD}" ]; then
	add_cmd="equo install ${PACKAGES_TO_ADD}"
	chroot "${tmp_dir}" ${add_cmd} || exit 1
fi
if [ -n "${PACKAGES_TO_REMOVE}" ]; then
	rem_cmd="equo remove ${PACKAGES_TO_REMOVE}"
	chroot "${tmp_dir}" ${rem_cmd} || exit 1
fi

# execute CHROOT_SCRIPT hook inside chroot
chroot_script_name=$(basename "${CHROOT_SCRIPT}")
target_chroot_script="${tmp_dir}"/"${chroot_script_name}"
cp -p "${CHROOT_SCRIPT}" "${target_chroot_script}" || exit 1
chmod 700 "${target_chroot_script}" || exit 1
chown root "${target_chroot_script}" || exit 1
chroot "${tmp_dir}" "/${chroot_script_name}" || exit 1
rm -f "${target_chroot_script}"

CHROOT_DIR="${tmp_dir}" "${SABAYON_MOLECULE_HOME}"/scripts/mmc_remaster_post.sh

# execute final cleanup of entropy stuff
chroot "${tmp_dir}" equo rescue vacuum

# setup sudoers, enable wheel group
if [ -f "${tmp_dir}/etc/sudoers" ]; then
	echo "# added by Sabayon Molecule" >> "${tmp_dir}/etc/sudoers"
	echo "%wheel  ALL=ALL" >> "${tmp_dir}/etc/sudoers"
fi

export LC_ALL=C

# work out paths to empty and paths to remove
if [ -n "${PATHS_TO_REMOVE}" ]; then
	set -f
	for path in $(echo ${PATHS_TO_REMOVE} | tr ";" "\n"); do
		echo "Removing: ${path}"
		set +f
		rm -rf "${tmp_dir}"/${path}
		set -f
	done
	set +f
fi
if [ -n "${PATHS_TO_EMPTY}" ]; then
	set -f
	for path in $(echo ${PATHS_TO_EMPTY} | tr ";" "\n"); do
		set +f
		echo "Emptying: ${path}"
		rm -rf "${tmp_dir}"/"${path}"/*
		set -f
	done
	set +f
fi

if [ -n "${RELEASE_FILE}" ]; then
	release_file="${tmp_dir}"/"${RELEASE_FILE}"
	release_dir=$(dirname "${release_file}")
	[[ ! -d "${release_dir}" ]] && { mkdir -p "${release_dir}" || exit 1; }
	echo "${RELEASE_STRING} ${RELEASE_VERSION} ${RELEASE_DESC}" > "${release_file}"
fi

# BOOT_PART_TYPE_INSIDE_ROOT
if [ -n "${BOOT_PART_TYPE_INSIDE_ROOT}" ]; then
	echo "Copying data from ${tmp_dir}/boot to ${boot_tmp_dir} as requested..."
	cp -Rp "${tmp_dir}/boot/"* "${boot_tmp_dir}/" || exit 1
fi
umount "${boot_tmp_dir}" || exit 1


if [ -n "${DESTINATION_IMAGE_DIR}" ] && [ "${MAKE_TARBALL}" = "1" ]; then
	# Create the rootfs tarball
	ROOTFS_TARBALL="${DESTINATION_IMAGE_DIR}/${IMAGE_NAME}.rootfs.tar.xz"
	echo "Creating the roofs tarball: ${ROOTFS_TARBALL}"
	tmp_file=$(mktemp --suffix=.tar.xz)
	[[ -z "${tmp_file}" ]] && exit 1
	cd "${tmp_dir}" || exit 1
	tar --numeric-owner --preserve-permissions --same-owner -cJf "${tmp_file}" ./ || exit 1
	mv "${tmp_file}" "${ROOTFS_TARBALL}" || exit 1
	chmod 644 "${ROOTFS_TARBALL}" || exit 1
	cd "$(dirname "${ROOTFS_TARBALL}")" || exit 1
	md5sum "$(basename "${ROOTFS_TARBALL}")" > "$(basename "${ROOTFS_TARBALL}")".md5
fi

umount "${tmp_dir}" || exit 1

cleanup_loopbacks
echo "Your MMC image \"${FILE}\" is ready"
