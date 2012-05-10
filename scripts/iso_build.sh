#!/bin/bash

ACTION="${1}"
if [ "${ACTION}" != "daily" ] && [ "${ACTION}" != "weekly" ]; then
	echo "invalid action: ${ACTION}" >&2
	exit 1
fi
shift

for arg in "$@"
do
	[[ "${arg}" = "--push" ]] && DO_PUSH="1"
	[[ "${arg}" = "--stdout" ]] && DO_STDOUT="1"
	if [ "${arg}" = "--pushonly" ]; then
		DO_PUSH="1"
		DRY_RUN="1"
	fi
done

CUR_DATE=$(date -u +%Y%m%d)
LOG_FILE="/var/log/molecule/autobuild-${CUR_DATE}-${$}.log"
BUILDING_DAILY=1
MAKE_TORRENTS="${MAKE_TORRENTS:-0}"

# to make ISO remaster spec files working (pre_iso_script)
export CUR_DATE
export ETP_NONINTERACTIVE=1
export BUILDING_DAILY

echo "DO_PUSH=${DO_PUSH}"
echo "DRY_RUN=${DRY_RUN}"
echo "LOG_FILE=${LOG_FILE}"

# setup default language, cron might not do that
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

if [ "${ACTION}" = "weekly" ]; then
	ARM_SOURCE_SPECS=(
		"sabayon-arm-beaglebone-base-2G.spec"
		"sabayon-arm-beaglebone-base-4G.spec"
		"sabayon-arm-beagleboard-xm-4G.spec"
		"sabayon-arm-beagleboard-xm-8G.spec"
		"sabayon-arm-pandaboard-4G.spec"
		"sabayon-arm-pandaboard-8G.spec"
		"sabayon-arm-efikamx-base-4G.spec"
	)
	ARM_SOURCE_SPECS_IMG=(
		"Sabayon_Linux_DAILY_armv7a_BeagleBone_Base_2GB.img"
		"Sabayon_Linux_DAILY_armv7a_BeagleBone_Base_4GB.img"
		"Sabayon_Linux_DAILY_armv7a_BeagleBoard_xM_4GB.img"
		"Sabayon_Linux_DAILY_armv7a_BeagleBoard_xM_8GB.img"
		"Sabayon_Linux_DAILY_armv7a_PandaBoard_4GB.img"
		"Sabayon_Linux_DAILY_armv7a_PandaBoard_8GB.img"
		"Sabayon_Linux_DAILY_armv7a_EfikaMX_Base_4GB.img"
	)
	SOURCE_SPECS=()
	SOURCE_SPECS_ISO=()
	REMASTER_SPECS=(
                "sabayon-amd64-xfceforensic.spec"
                "sabayon-x86-xfceforensic.spec"
	)
	REMASTER_SPECS_ISO=(
                "Sabayon_Linux_DAILY_amd64_ForensicsXfce.iso"
                "Sabayon_Linux_DAILY_x86_ForensicsXfce.iso"
	)
elif [ "${ACTION}" = "daily" ]; then
	ARM_SOURCE_SPECS=()
	ARM_SOURCE_SPECS_IMG=()
	SOURCE_SPECS=(
		"sabayon-x86-spinbase.spec"
		"sabayon-amd64-spinbase.spec"
	)
	SOURCE_SPECS_ISO=(
		"Sabayon_Linux_SpinBase_DAILY_x86.iso"
		"Sabayon_Linux_SpinBase_DAILY_amd64.iso"
	)
	REMASTER_SPECS=(
		"sabayon-amd64-gnome.spec"
		"sabayon-x86-gnome.spec"
		"sabayon-amd64-kde.spec"
		"sabayon-x86-kde.spec"

		"sabayon-amd64-lxde.spec"
		"sabayon-x86-lxde.spec"
		"sabayon-amd64-xfce.spec"
		"sabayon-x86-xfce.spec"
		"sabayon-amd64-e17.spec"
		"sabayon-x86-e17.spec"
		"sabayon-amd64-corecdx.spec"
		"sabayon-x86-corecdx.spec"
		"sabayon-amd64-serverbase.spec"
		"sabayon-x86-serverbase.spec"
	)
	REMASTER_SPECS_ISO=(
		"Sabayon_Linux_DAILY_amd64_G.iso"
		"Sabayon_Linux_DAILY_x86_G.iso"
		"Sabayon_Linux_DAILY_amd64_K.iso"
		"Sabayon_Linux_DAILY_x86_K.iso"
		"Sabayon_Linux_DAILY_amd64_LXDE.iso"
		"Sabayon_Linux_DAILY_x86_LXDE.iso"
		"Sabayon_Linux_DAILY_amd64_Xfce.iso"
		"Sabayon_Linux_DAILY_x86_Xfce.iso"
		"Sabayon_Linux_DAILY_amd64_E17.iso"
		"Sabayon_Linux_DAILY_x86_E17.iso"
		"Sabayon_Linux_CoreCDX_DAILY_amd64.iso"
		"Sabayon_Linux_CoreCDX_DAILY_x86.iso"
		"Sabayon_Linux_ServerBase_DAILY_amd64.iso"
		"Sabayon_Linux_ServerBase_DAILY_x86.iso"
	)
fi

[[ -d "/sabayon/molecules/daily" ]] || mkdir -p /sabayon/molecules/daily
[[ -d "/sabayon/molecules/daily/remaster" ]] || mkdir -p /sabayon/molecules/daily/remaster
[[ -d "/var/log/molecule" ]] || mkdir -p /var/log/molecule


move_to_pkg_sabayon_org() {
	if [ -n "${DO_PUSH}" ] || [ -f /sabayon/DO_PUSH ]; then
		rm -f /sabayon/DO_PUSH
		rsync -av --partial --delete-excluded /sabayon/iso_rsync/*DAILY* \
	       	        entropy@pkg.sabayon.org:/sabayon/rsync/rsync.sabayon.org/iso/daily
	fi
}

build_sabayon() {
	if [ -z "${DRY_RUN}" ]; then
		rm -rf /sabayon/molecules/daily/*.spec
		rm -rf /sabayon/molecules/daily/remaster/*.spec

		local source_specs=""
		for i in ${!SOURCE_SPECS[@]}
		do
			src="/sabayon/molecules/${SOURCE_SPECS[i]}"
			dst="/sabayon/molecules/daily/${SOURCE_SPECS[i]}"
			cp "${src}" "${dst}" -p || return 1
			echo >> "${dst}"
			echo "inner_source_chroot_script: /sabayon/scripts/inner_source_chroot_update.sh" >> "${dst}"
			# tweak iso image name
			sed -i "s/^#.*destination_iso_image_name/destination_iso_image_name:/" "${dst}" || return 1
			sed -i "s/destination_iso_image_name.*/destination_iso_image_name: ${SOURCE_SPECS_ISO[i]}/" "${dst}" || return 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || return 1
			echo "${dst}: iso: ${SOURCE_SPECS_ISO[i]} date: ${CUR_DATE}"
			source_specs+="${dst} "
		done

		local arm_source_specs=""
		for i in ${!ARM_SOURCE_SPECS[@]}
		do
			src="/sabayon/molecules/${ARM_SOURCE_SPECS[i]}"
			dst="/sabayon/molecules/daily/${ARM_SOURCE_SPECS[i]}"
			cp "${src}" "${dst}" -p || return 1
			echo >> "${dst}"
			echo "inner_source_chroot_script: /sabayon/scripts/inner_source_chroot_update.sh" >> "${dst}"
			# tweak iso image name
			sed -i "s/^#.*image_name/image_name:/" "${dst}" || return 1
			sed -i "s/image_name.*/image_name: ${ARM_SOURCE_SPECS_IMG[i]}/" "${dst}" || return 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || return 1
			echo "${dst}: image: ${ARM_SOURCE_SPECS_IMG[i]} date: ${CUR_DATE}"
			arm_source_specs+="${dst} "
		done

		local remaster_specs=""
		for i in ${!REMASTER_SPECS[@]}
		do
			src="/sabayon/molecules/${REMASTER_SPECS[i]}"
			dst="/sabayon/molecules/daily/remaster/${REMASTER_SPECS[i]}"
			cp "${src}" "${dst}" -p || return 1
			# tweak iso image name
			sed -i "s/^#.*destination_iso_image_name/destination_iso_image_name:/" "${dst}" || return 1
			sed -i "s/destination_iso_image_name.*/destination_iso_image_name: ${REMASTER_SPECS_ISO[i]}/" "${dst}" || return 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || return 1
			echo "${dst}: iso: ${REMASTER_SPECS_ISO[i]} date: ${CUR_DATE}"
			remaster_specs+="${dst} "
		done

		for i in ${!REMASTER_OPENVZ_SPECS[@]}
		do
			src="/sabayon/molecules/${REMASTER_OPENVZ_SPECS[i]}"
			dst="/sabayon/molecules/daily/remaster/${REMASTER_OPENVZ_SPECS[i]}"
			cp "${src}" "${dst}" -p || return 1
			# tweak tar name
			sed -i "s/^#.*tar_name/tar_name:/" "${dst}" || return 1
			sed -i "s/tar_name.*/tar_name: ${REMASTER_OPENVZ_SPECS_TAR[i]}/" "${dst}" || return 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || return 1
			echo "${dst}: iso: ${REMASTER_OPENVZ_SPECS_TAR[i]} date: ${CUR_DATE}"
			remaster_specs+="${dst} "
		done

		local done_images=0
		local done_something=0
		if [ -n "${arm_source_specs}" ]; then
			molecule --nocolor ${arm_source_specs} || return 1
			done_something=1
			done_images=1
		fi
		if [ -n "${source_specs}" ]; then
			molecule --nocolor ${source_specs} || return 1
			done_something=1
		fi
		if [ -n "${remaster_specs}" ]; then
			molecule --nocolor ${remaster_specs} || return 1
			done_something=1
		fi
		if [ "${done_something}" = "1" ]; then
			if [ "${done_images}" = "1" ]; then
				cp /sabayon/images/*DAILY* /sabayon/iso_rsync/ || return 1
			fi
			cp /sabayon/iso/*DAILY* /sabayon/iso_rsync/ || return 1
			date > /sabayon/iso_rsync/RELEASE_DATE_DAILY
			if [ "${MAKE_TORRENTS}" != "0" ]; then
				/sabayon/scripts/make_torrents.sh || return 1
			fi
		fi
	fi
	return 0
}

out="0"
if [ -n "${DO_STDOUT}" ]; then
	build_sabayon
	out=${?}
	if [ "${out}" = "0" ]; then
		move_to_pkg_sabayon_org
		out=${?}
	fi
else
	log_file="/var/log/molecule/autobuild-${CUR_DATE}-${$}.log"
	build_sabayon &> "${log_file}"
	out=${?}
	if [ "${out}" = "0" ]; then
		move_to_pkg_sabayon_org &>> "${log_file}"
		out=${?}
	fi
fi
echo "EXIT_STATUS: ${out}"

CUR_DAY=$(date -u +%d)
if [ "${CUR_DAY}" = "01" ]; then
	rm -rf /sabayon/pkgcache/*
fi
exit ${out}
