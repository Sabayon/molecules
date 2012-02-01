#! /bin/sh
# (c) Copyright 2012 Fabio Erculiani <lxnay@sabayon.org>
# Licensed under terms of GPLv2

env-update
. /etc/profile

export LC_ALL=C

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

cleanup_loopbacks() {
	cd /
	sync
	sync
	sleep 5
	sync
	[[ -n "${tmp_file}" ]] && rm "${tmp_file}" 2> /dev/null
	[[ -n "${tmp_dir}" ]] && { umount "${tmp_dir}" &> /dev/null; rmdir "${tmp_dir}" &> /dev/null; }
	sleep 1
	[[ -n "${vfat_part}" ]] && losetup -d "${vfat_part}" 2> /dev/null
	[[ -n "${ext_part}" ]] && losetup -d "${ext_part}" 2> /dev/null
	[[ -n "${DRIVE}" ]] && losetup -d "${DRIVE}" 2> /dev/null
	# make sure to have run this
	[[ -n "${CHROOT_DIR}" ]] && /sabayon/scripts/mmc_remaster_post.sh
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
echo ,9,0x0C,*
echo ,,,-
} | sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE

sleep 2

# The second partiton will start at block 144585, get the end block
ENDBLOCK=$(fdisk -l "${DRIVE}" | grep "${DRIVE}p2" | awk '{print $3}')
EXTSIZE=$(((ENDBLOCK - 144585) * 512))
# Get other two loopback devices first
EXTOFFSET=$((STARTOFFSET + MAGICSIZE))

echo "ExtFS size   : ${EXTSIZE} bytes"
echo "ExtFS offset : ${EXTOFFSET} bytes"

# Get other two loopback devices first
vfat_part=$(losetup -f --offset "${STARTOFFSET}" --sizelimit "${MAGICSIZE}" "${FILE}" --show)
if [ -z "${vfat_part}" ]; then
	echo "Cannot setup the vfat partition loopback"
	exit 1
fi


ext_part=$(losetup -f --offset "${EXTOFFSET}" --sizelimit "${EXTSIZE}" "${FILE}" --show)
if [ -z "${ext_part}" ]; then
	echo "Cannot setup the ext3 partition loopback"
	exit 1
fi

echo "VFAT Partiton at   : ${vfat_part}"
echo "ExtFS Partition at : ${ext_part}"

# Format vfat
echo "Formatting VFAT ${vfat_part}..."
mkfs.vfat -n "boot" -F 32 "${vfat_part}" || exit 1

# Format extfs
echo "Formatting ExtFS ${ext_part}..."
mkfs.ext3 -L "Sabayon" "${ext_part}" || exit 1

tmp_dir=$(mktemp -d)
if [[ -z "${tmp_dir}" ]]; then
	echo "Cannot create temporary dir"
	exit 1
fi
chmod 755 "${tmp_dir}" || exit 1

sleep 2
sync

echo "Setting up the boot directory content, mounting on ${tmp_dir}"
mount "${vfat_part}" "${tmp_dir}"
cp -R "${BOOT_DIR}"/* "${tmp_dir}"/ || exit 1
umount "${tmp_dir}" || exit 1

echo "Setting up the extfs directory content, mounting on ${tmp_dir}"
mount "${ext_part}" "${tmp_dir}"
rsync -a -H -A -X --delete-during "${CHROOT_DIR}"/ "${tmp_dir}"/ --exclude "/proc/*" --exclude "/sys/*" \
	--exclude "/dev/pts/*" --exclude "/dev/shm/*" || exit 1

[[ -n "${CHROOT_DIR}" ]] && /sabayon/scripts/remaster_pre.sh || exit 1

# Configure 00-board-setup.start
source_board_setup="/sabayon/boot/arm_startup/00-board-setup.start"
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

[[ -n "${CHROOT_DIR}" ]] && /sabayon/scripts/mmc_remaster_post.sh

# execute final cleanup of entropy stuff
chroot "${tmp_dir}" equo rescue vacuum

export LC_ALL=C

# work out paths to empty and paths to remove
if [ -n "${PATHS_TO_REMOVE}" ]; then
	for path in $(echo ${PATHS_TO_REMOVE} | tr ";" "\n"); do
		echo "Removing: ${path}"
		rm -rf "${tmp_dir}"/${path}
	done
fi
if [ -n "${PATHS_TO_EMPTY}" ]; then
	for path in $(echo ${PATHS_TO_EMPTY} | tr ";" "\n"); do
		echo "Emptying: ${path}"
		rm -rf "${tmp_dir}"/"${path}"/*
	done
fi

if [ -n "${RELEASE_FILE}" ]; then
	release_file="${tmp_dir}"/"${RELEASE_FILE}"
	release_dir=$(dirname "${release_file}")
	[[ ! -d "${release_dir}" ]] && { mkdir -p "${release_dir}" || exit 1; }
	echo "${RELEASE_STRING} ${RELEASE_VERSION} ${RELEASE_DESC}" > "${release_file}"
fi

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
