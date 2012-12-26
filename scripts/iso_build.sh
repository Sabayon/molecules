#!/bin/bash

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

ACTION="${1}"
if [ "${ACTION}" != "daily" ] && [ "${ACTION}" != "weekly" ] && [ "${ACTION}" != "dailybase" ]; then
	echo "invalid action: ${ACTION}" >&2
	exit 1
fi
shift

for arg in "$@"
do
	[[ "${arg}" = "--push" ]] && DO_PUSH="1"
	[[ "${arg}" = "--stdout" ]] && DO_STDOUT="1"
	[[ "${arg}" = "--sleepnight" ]] && DO_SLEEPNIGHT="1"
	if [ "${arg}" = "--pushonly" ]; then
		DO_PUSH="1"
		DRY_RUN="1"
	fi
done

CUR_DATE=$(date -u +%Y%m%d)
LOG_FILE="/var/log/molecule/autobuild-${CUR_DATE}-${$}.log"
BUILDING_DAILY=1
MAKE_TORRENTS="${MAKE_TORRENTS:-0}"
DAILY_TMPDIR=

# to make ISO remaster spec files working (pre_iso_script)
export CUR_DATE
export ETP_NONINTERACTIVE=1
export BUILDING_DAILY
# Temporarily added to debug Equo in case of deadlock
# export ETP_DEBUG_WATCHDOG=1
# export ETP_DEBUG_WATCHDOG_INTERVAL=60

echo "DO_PUSH=${DO_PUSH}"
echo "DRY_RUN=${DRY_RUN}"
echo "DO_SLEEPNIGHT=${DO_SLEEPNIGHT}"
echo "LOG_FILE=${LOG_FILE}"

# setup default language, cron might not do that
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# Sleep until 22pm?
if [ "${DO_SLEEPNIGHT}" = "1" ] && [ "${DO_PUSH}" = "1" ]; then
	target_h=22 # 22pm
	current_h=$(date +%H)
	current_h=${current_h/0} # remove leading 0
	delta_h=$(( target_h - current_h ))
	if [ ${current_h} -ge 0 ] && [ ${current_h} -le 6 ]; then
		# If it's past midnight and no later than 7am
		# just push
		echo "Just pusing out now"
	elif [ ${delta_h} -gt 0 ]; then
		delta_s=$(( delta_h * 3600 ))
		echo "Sleeping for ${delta_h} hours..."
		sleep ${delta_s} || exit 1
	elif [ ${delta_h} -lt 0 ]; then
		# between 22 and 24, run!
		echo "I'm after 22pm, running"
	else
		echo "No need to sleep"
	fi
fi

ARM_SOURCE_SPECS=()
ARM_SOURCE_SPECS_IMG=()

SOURCE_SPECS=()
SOURCE_SPECS_ISO=()

REMASTER_SPECS=()
REMASTER_SPECS_ISO=()
REMASTER_TAR_SPECS=()
REMASTER_TAR_SPECS_TAR=()

if [ "${ACTION}" = "weekly" ] || [ "${ACTION}" = "daily" ]; then

	# Daily molecules
	SOURCE_SPECS+=(
		"sabayon-x86-spinbase.spec"
		"sabayon-amd64-spinbase.spec"
	)
	SOURCE_SPECS_ISO+=(
		"Sabayon_Linux_SpinBase_DAILY_x86.iso"
		"Sabayon_Linux_SpinBase_DAILY_amd64.iso"
	)
	REMASTER_SPECS+=(
		"sabayon-amd64-gnome.spec"
		"sabayon-x86-gnome.spec"
		"sabayon-amd64-kde.spec"
		"sabayon-x86-kde.spec"
		"sabayon-amd64-mate.spec"
		"sabayon-x86-mate.spec"
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
		"sabayon-amd64-hardenedserver.spec"
		"sabayon-x86-hardenedserver.spec"
	)
	REMASTER_SPECS_ISO+=(
		"Sabayon_Linux_DAILY_amd64_G.iso"
		"Sabayon_Linux_DAILY_x86_G.iso"
		"Sabayon_Linux_DAILY_amd64_K.iso"
		"Sabayon_Linux_DAILY_x86_K.iso"
                "Sabayon_Linux_DAILY_amd64_MATE.iso"
                "Sabayon_Linux_DAILY_x86_MATE.iso"
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
		"Sabayon_Linux_HardenedServer_DAILY_amd64.iso"
		"Sabayon_Linux_HardenedServer_DAILY_x86.iso"
	)


	# Weekly molecules
	if [ "${ACTION}" = "weekly" ]; then
		ARM_SOURCE_SPECS+=(
			"sabayon-arm-beaglebone-base-2G.spec"
			"sabayon-arm-beaglebone-base-4G.spec"
			"sabayon-arm-beagleboard-xm-4G.spec"
			"sabayon-arm-beagleboard-xm-8G.spec"
			"sabayon-arm-pandaboard-4G.spec"
			"sabayon-arm-pandaboard-8G.spec"
			"sabayon-arm-efikamx-base-4G.spec"
		)
		ARM_SOURCE_SPECS_IMG+=(
			"Sabayon_Linux_DAILY_armv7a_BeagleBone_Base_2GB.img"
			"Sabayon_Linux_DAILY_armv7a_BeagleBone_Base_4GB.img"
			"Sabayon_Linux_DAILY_armv7a_BeagleBoard_xM_4GB.img"
			"Sabayon_Linux_DAILY_armv7a_BeagleBoard_xM_8GB.img"
			"Sabayon_Linux_DAILY_armv7a_PandaBoard_4GB.img"
			"Sabayon_Linux_DAILY_armv7a_PandaBoard_8GB.img"
			"Sabayon_Linux_DAILY_armv7a_EfikaMX_Base_4GB.img"
		)
		REMASTER_SPECS+=(
			"sabayon-amd64-xfceforensic.spec"
			"sabayon-x86-xfceforensic.spec"
		)
		REMASTER_SPECS_ISO+=(
			"Sabayon_Linux_DAILY_amd64_ForensicsXfce.iso"
			"Sabayon_Linux_DAILY_x86_ForensicsXfce.iso"
		)
		REMASTER_TAR_SPECS+=(
			"sabayon-x86-spinbase-openvz-template.spec"
			"sabayon-amd64-spinbase-openvz-template.spec"
			"sabayon-x86-spinbase-amazon-ebs-image.spec"
			"sabayon-amd64-spinbase-amazon-ebs-image.spec"
		)
		REMASTER_TAR_SPECS_TAR+=(
			"Sabayon_Linux_SpinBase_DAILY_x86_openvz.tar.gz"
			"Sabayon_Linux_SpinBase_DAILY_amd64_openvz.tar.gz"
			"Sabayon_Linux_SpinBase_DAILY_x86_Amazon_EBS_ext4_filesystem_image.tar.gz"
			"Sabayon_Linux_SpinBase_DAILY_amd64_Amazon_EBS_ext4_filesystem_image.tar.gz"
		)
	fi

elif [ "${ACTION}" = "dailybase" ]; then
	SOURCE_SPECS=(
		"sabayon-x86-spinbase.spec"
		"sabayon-amd64-spinbase.spec"
	)
	SOURCE_SPECS_ISO=(
		"Sabayon_Linux_SpinBase_DAILY_x86.iso"
		"Sabayon_Linux_SpinBase_DAILY_amd64.iso"
	)
fi

[[ -d "/var/log/molecule" ]] || mkdir -p /var/log/molecule

cleanup_on_exit() {
	if [ -n "${DAILY_TMPDIR}" ] && [ -d "${DAILY_TMPDIR}" ]; then
		rm -rf "${DAILY_TMPDIR}"
		# don't care about races
		DAILY_TMPDIR=""
	fi
}
trap "cleanup_on_exit" EXIT INT TERM

move_to_pkg_sabayon_org() {
	if [ -n "${DO_PUSH}" ] || [ -f "${SABAYON_MOLECULE_HOME}"/DO_PUSH ]; then
		rm -f "${SABAYON_MOLECULE_HOME}"/DO_PUSH
		local executed=
		for ((i=0; i < 5; i++)); do
			rsync -av --partial --delete-excluded "${SABAYON_MOLECULE_HOME}"/iso_rsync/*DAILY* \
				entropy@pkg.sabayon.org:/sabayon/rsync/rsync.sabayon.org/iso/daily \
				|| { sleep 10; continue; }
			rsync -av --partial --delete-excluded "${SABAYON_MOLECULE_HOME}"/scripts/gen_html \
			entropy@pkg.sabayon.org:/sabayon/rsync/iso_html_generator \
				|| { sleep 10; continue; }
			ssh entropy@pkg.sabayon.org \
				/sabayon/rsync/iso_html_generator/gen_html/gen.sh \
				|| { sleep 10; continue; }
			executed=1
			break
		done
		[[ -n "${executed}" ]] && return 0
		return 1
	fi
	return 0
}

build_sabayon() {
	if [ -z "${DRY_RUN}" ]; then

		DAILY_TMPDIR=$(mktemp -d --suffix=.iso_build.sh --tmpdir=/tmp)
		[[ -z "${DAILY_TMPDIR}" ]] && return 1
		DAILY_TMPDIR_REMASTER="${DAILY_TMPDIR}/remaster"
		mkdir "${DAILY_TMPDIR_REMASTER}" || return 1

		local source_specs=""
		for i in ${!SOURCE_SPECS[@]}
		do
			src="${SABAYON_MOLECULE_HOME}/molecules/${SOURCE_SPECS[i]}"
			dst="${DAILY_TMPDIR}/${SOURCE_SPECS[i]}"
			cp "${src}" "${dst}" -p || return 1
			echo >> "${dst}"
			echo "inner_source_chroot_script: ${SABAYON_MOLECULE_HOME}/scripts/inner_source_chroot_update.sh" >> "${dst}"
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
			src="${SABAYON_MOLECULE_HOME}/molecules/${ARM_SOURCE_SPECS[i]}"
			dst="${DAILY_TMPDIR}/${ARM_SOURCE_SPECS[i]}"
			cp "${src}" "${dst}" -p || return 1
			echo >> "${dst}"
			echo "inner_source_chroot_script: ${SABAYON_MOLECULE_HOME}/scripts/inner_source_chroot_update.sh" >> "${dst}"
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
			src="${SABAYON_MOLECULE_HOME}/molecules/${REMASTER_SPECS[i]}"
			dst="${DAILY_TMPDIR_REMASTER}/${REMASTER_SPECS[i]}"
			cp "${src}" "${dst}" -p || return 1
			# tweak iso image name
			sed -i "s/^#.*destination_iso_image_name/destination_iso_image_name:/" "${dst}" || return 1
			sed -i "s/destination_iso_image_name.*/destination_iso_image_name: ${REMASTER_SPECS_ISO[i]}/" "${dst}" || return 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || return 1
			echo "${dst}: iso: ${REMASTER_SPECS_ISO[i]} date: ${CUR_DATE}"
			remaster_specs+="${dst} "
		done

		for i in ${!REMASTER_TAR_SPECS[@]}
		do
			src="${SABAYON_MOLECULE_HOME}/molecules/${REMASTER_TAR_SPECS[i]}"
			dst="${DAILY_TMPDIR_REMASTER}/${REMASTER_TAR_SPECS[i]}"
			cp "${src}" "${dst}" -p || return 1
			# tweak tar name
			sed -i "s/^#.*tar_name/tar_name:/" "${dst}" || return 1
			sed -i "s/tar_name.*/tar_name: ${REMASTER_TAR_SPECS_TAR[i]}/" "${dst}" || return 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || return 1
			echo "${dst}: tar: ${REMASTER_TAR_SPECS_TAR[i]} date: ${CUR_DATE}"
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

		# package phases keep loading dbus, let's kill pids back
		ps ax | grep -- "/usr/bin/dbus-daemon --fork .* --session" | awk '{ print $1 }' | xargs kill 2> /dev/null

		if [ "${done_something}" = "1" ]; then
			if [ "${done_images}" = "1" ]; then
				cp -p "${SABAYON_MOLECULE_HOME}"/images/*DAILY* "${SABAYON_MOLECULE_HOME}"/iso_rsync/ || return 1
			fi
			cp -p "${SABAYON_MOLECULE_HOME}"/iso/*DAILY* "${SABAYON_MOLECULE_HOME}"/iso_rsync/ || return 1
			date > "${SABAYON_MOLECULE_HOME}"/iso_rsync/RELEASE_DATE_DAILY
			if [ "${MAKE_TORRENTS}" != "0" ]; then
				"${SABAYON_MOLECULE_HOME}"/scripts/make_torrents.sh || return 1
			fi
		fi
	fi
	return 0
}

mail_failure() {
	local out=${1}
	local log_file=${2}
	local log_cont=

	# get the last 64 lines of the file
	if [ -f "${log_file}" ]; then
		log_cont=$(tail -n 64 "${log_file}" 2> /dev/null)
	fi

	echo "Hello there,
iso_build.sh execution failed (miserably) with exit status: ${out}.
Log file is at: ${log_file}

Last log lines:
[... snip ...]
${log_cont}
[... snip ...]

Thanks,
Sun" | /bin/mail -s "ISO build script failure" root
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
	if [ "${out}" != "0" ]; then
		# mail root
		mail_failure "${out}" "${log_file}"
	fi
fi
echo "EXIT_STATUS: ${out}"

exit ${out}
