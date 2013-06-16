#! /bin/bash
# (c) Copyright 2012 Fabio Erculiani <lxnay@sabayon.org>
# Licensed under terms of GPLv2

/usr/sbin/env-update
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
MAKE_TARBALL="${MAKE_TARBALL:-0}"
SD_FUSE="${SD_FUSE:-}"
DTB_FILES="${DTB_FILES:-}"
# Boot partition type
FIRST_PARTITION_START_CYL="${FIRST_PARTITION_START_CYL:-0}"
BOOT_PART_TYPE="${BOOT_PART_TYPE:-vfat}"
BOOT_PART_TYPE_MBR="${BOOT_PART_TYPE_MBR:-0x0C}"
BOOT_PART_MKFS_ARGS="${BOOT_PART_MKFS_ARGS:--n boot -F 32}"
# Root partition type
ROOT_PART_TYPE="${ROOT_PART_TYPE:-ext3}"
ROOT_PART_MKFS_ARGS="${ROOT_PART_MKFS_ARGS:--L Sabayon}"
# Copy /boot content from Root partition to Boot partition?
BOOT_PART_TYPE_INSIDE_ROOT="${BOOT_PART_TYPE_INSIDE_ROOT:-}"

# Using /tmp is bad and triggers monitoring notifications
export TMPDIR=/var/tmp

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
dd if=/dev/zero of="${FILE}" bs=1024000 count="${SIZE}" || exit 1

DRIVE=$(losetup -f "${FILE}" --show)
if [ -z "${DRIVE}" ]; then
	echo "Cannot execute losetup for $FILE"
	exit 1
fi

echo "Configured the loopback partition at ${DRIVE}"

# Calculate size using fdisk
SIZE=$(fdisk -l "${DRIVE}" | grep Disk | grep bytes | awk '{print $5}')
CYLINDERS=$((SIZE/255/63/512))
BOOTPART_CYLS=9
ENDSECT=$(( 144584 + (EMPTYSIZE/512) ))

echo "Disk size           : ${SIZE} bytes"
echo "Disk cyls           : ${CYLINDERS}"
echo "Boot p. cyls        : ${BOOTPART_CYLS}"
echo "Boot p. start cyls  : ${FIRST_PARTITION_START_CYL}"
echo "End block           : ${ENDSECT} block"

{
echo ${FIRST_PARTITION_START_CYL},${BOOTPART_CYLS},${BOOT_PART_TYPE_MBR},*
echo $(( BOOTPART_CYLS + FIRST_PARTITION_START_CYL )),,,-
} | sfdisk -D -H 255 -S 63 -C ${CYLINDERS} ${DRIVE}

sleep 2

BOOT_STARTBLOCK=$(fdisk -l "${DRIVE}" | grep "${DRIVE}p1" | awk '{print $3}')
if [ -z "${BOOT_STARTBLOCK}" ]; then
	echo "No BOOT_STARTBLOCK" >&2
	exit 1
fi
BOOT_ENDBLOCK=$(fdisk -l "${DRIVE}" | grep "${DRIVE}p1" | awk '{print $4}')
if [ -z "${BOOT_ENDBLOCK}" ]; then
	echo "No BOOT_ENDBLOCK" >&2
	exit 1
fi

BOOT_STARTOFFSET=$(( BOOT_STARTBLOCK * 512 ))
BOOT_ENDOFFSET=$(( BOOT_ENDBLOCK * 512 ))
BOOT_MAGICSIZE=$(( BOOT_ENDOFFSET - BOOT_STARTOFFSET ))
echo "Boot start offset : ${BOOT_STARTOFFSET} bytes"
echo "Boot start block  : ${BOOT_STARTBLOCK} block"
echo "Boot end block    : ${BOOT_ENDBLOCK} block"
echo "Boot size         : ${BOOT_MAGICSIZE} bytes"

ROOT_STARTBLOCK=$(fdisk -l "${DRIVE}" | grep "${DRIVE}p2" | awk '{print $2}')
if [ -z "${ROOT_STARTBLOCK}" ]; then
	echo "No ROOT_STARTBLOCK" >&2
	exit 1
fi
ROOT_ENDBLOCK=$(fdisk -l "${DRIVE}" | grep "${DRIVE}p2" | awk '{print $3}')
if [ -z "${ROOT_ENDBLOCK}" ]; then
	echo "No ROOT_ENDBLOCK" >&2
	exit 1
fi

ROOT_STARTOFFSET=$(( ROOT_STARTBLOCK * 512 ))
ROOT_ENDOFFSET=$(( ROOT_ENDBLOCK * 512 ))
ROOT_MAGICSIZE=$(( ROOT_ENDOFFSET - ROOT_STARTOFFSET ))
echo "Root start offset : ${ROOT_STARTOFFSET} bytes"
echo "Root start block  : ${ROOT_STARTBLOCK} block"
echo "Root end block    : ${ROOT_ENDBLOCK} block"
echo "Root size         : ${ROOT_MAGICSIZE} bytes"

# Get other two loopback devices first
boot_part=$(losetup -f --offset "${BOOT_STARTOFFSET}" --sizelimit "${BOOT_MAGICSIZE}" "${FILE}" --show)
if [ -z "${boot_part}" ]; then
	echo "Cannot setup the boot partition loopback"
	exit 1
fi

root_part=$(losetup -f --offset "${ROOT_STARTOFFSET}" --sizelimit "${ROOT_MAGICSIZE}" "${FILE}" --show)
if [ -z "${root_part}" ]; then
	echo "Cannot setup the ${ROOT_PART_TYPE} partition loopback"
	exit 1
fi

echo "Boot Partiton at   : ${boot_part}"
echo "Root Partition at : ${root_part}"

# Format boot
echo "Formatting ${BOOT_PART_TYPE} ${boot_part}..."
"mkfs.${BOOT_PART_TYPE}" ${BOOT_PART_MKFS_ARGS} "${boot_part}" || exit 1

# Format rootfs
echo "Formatting ${ROOT_PART_TYPE} ${root_part}..."
"mkfs.${ROOT_PART_TYPE}" ${ROOT_PART_MKFS_ARGS} "${root_part}" || exit 1

sleep 2
sync

boot_tmp_dir=$(mktemp -d --suffix="boot_tmp_dir")
if [[ -z "${boot_tmp_dir}" ]]; then
	echo "Cannot create temporary dir (boot)"
	exit 1
fi
chmod 755 "${boot_tmp_dir}" || exit 1

tmp_dir=$(mktemp -d --suffix="root_tmp_dir")
if [[ -z "${tmp_dir}" ]]; then
	echo "Cannot create temporary dir"
	exit 1
fi
chmod 755 "${tmp_dir}" || exit 1

echo "Setting up the boot directory content, mounting on ${boot_tmp_dir}"
mount "${boot_part}" "${boot_tmp_dir}"
cp -R "${BOOT_DIR}"/* "${boot_tmp_dir}"/ || exit 1

echo "Setting up the rootfs directory content, mounting on ${tmp_dir}"
mount "${root_part}" "${tmp_dir}"
rsync -a -H -A -X --delete-during "${CHROOT_DIR}"/ "${tmp_dir}"/ --exclude "/proc/*" --exclude "/sys/*" \
	--exclude "/dev/pts/*" --exclude "/dev/shm/*" || exit 1

CHROOT_DIR="${tmp_dir}" "${SABAYON_MOLECULE_HOME}"/scripts/remaster_pre.sh || exit 1

# execute PACKAGES_TO_ADD and PACKAGES_TO_REMOVE
export ETP_NONINTERACTIVE=1
# Entropy doesn't like non-UTF locale encodings
export LC_ALL=en_US.UTF-8

# do I have to run "equo update?"
# If we are running outside the DAILY scope, it's
# better to do it here. If instead we're doing a
# DAILY, this is already done by other scripts.
if [ -z "${BUILDING_DAILY}" ]; then
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
chroot_hook_inc_name="mkloopcard_chroot.include"
chroot_hook_include="${SABAYON_MOLECULE_HOME}/scripts/${chroot_hook_inc_name}"
target_chroot_hook_inc="${tmp_dir}/${chroot_hook_inc_name}"
cp -p "${chroot_hook_include}" "${target_chroot_hook_inc}" || exit 1
chmod 0700 "${target_chroot_hook_inc}" || exit 1
cp -p "${CHROOT_SCRIPT}" "${target_chroot_script}" || exit 1
chmod 0700 "${target_chroot_script}" || exit 1
chown root "${target_chroot_script}" || exit 1
chroot "${tmp_dir}" "/${chroot_script_name}" || exit 1
rm -f "${target_chroot_script}" "${target_chroot_hook_inc}"

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

for dtb in ${DTB_FILES}; do
	echo "Requested to copy dtb: ${dtb}"
	# expect to have just one kernel installed
	dtb_files=$(find "${tmp_dir}/lib/dts" -name "${dtb}" -print)
	for dtb_file in ${dtb_files}; do
		echo "Copying dtb: ${dtb_file} to ${tmp_dir}/boot/"
		cp "${dtb_file}" "${tmp_dir}/boot/" || exit 1
	done
done

# BOOT_PART_TYPE_INSIDE_ROOT
if [ -n "${BOOT_PART_TYPE_INSIDE_ROOT}" ]; then
	echo "Copying data from ${tmp_dir}/boot to ${boot_tmp_dir} as requested..."
	if [ "${BOOT_PART_TYPE}" = "vfat" ]; then
		cp -rL "${tmp_dir}/boot/"* "${boot_tmp_dir}/" || exit 1
	else
		cp -rp "${tmp_dir}/boot/"* "${boot_tmp_dir}/" || exit 1
	fi
fi

umount "${boot_tmp_dir}" || exit 1

echo "Umounting cruft..."
umount -f "${tmp_dir}/"{proc,sys,dev/shm,dev/pts}

if [ -n "${DESTINATION_IMAGE_DIR}" ] && [ "${MAKE_TARBALL}" = "1" ]; then
	# Create the rootfs tarball
	ROOTFS_TARBALL="${DESTINATION_IMAGE_DIR}/${IMAGE_NAME}.rootfs.tar.xz"
	echo "Creating the roofs tarball: ${ROOTFS_TARBALL}"
	tmp_file=$(mktemp --suffix=.tar.xz)
	[[ -z "${tmp_file}" ]] && exit 1
	cd "${tmp_dir}" || exit 1
	tar --one-file-system --numeric-owner --preserve-permissions --same-owner -cJf "${tmp_file}" ./ || exit 1
	mv "${tmp_file}" "${ROOTFS_TARBALL}" || exit 1
	chmod 644 "${ROOTFS_TARBALL}" || exit 1
	cd "$(dirname "${ROOTFS_TARBALL}")" || exit 1
	md5sum "$(basename "${ROOTFS_TARBALL}")" > "$(basename "${ROOTFS_TARBALL}")".md5
fi

umount "${tmp_dir}" || exit 1

if [ -n "${SD_FUSE}" ] && [ -x "${SD_FUSE}" ]; then
	"${SD_FUSE}" "${DRIVE}" || exit 1
fi

cleanup_loopbacks
echo "Your MMC image \"${FILE}\" is ready"
