#!/bin/bash

for arg in $@
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

# to make ISO remaster spec files working (pre_iso_script)
export CUR_DATE
export ETP_NONINTERACTIVE=1

echo "DO_PUSH=${DO_PUSH}"
echo "DRY_RUN=${DRY_RUN}"
echo "LOG_FILE=${LOG_FILE}"

# setup default language, cron might not do that
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

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
	"sabayon-x86-gforensic.spec"
	"sabayon-x86-kforensic.spec"
	"sabayon-amd64-gaming.spec"
	"sabayon-x86-gaming.spec"
)
REMASTER_SPECS_ISO=(
	"Sabayon_Linux_DAILY_amd64_G.iso"
	"Sabayon_Linux_DAILY_x86_G.iso"
	"Sabayon_Linux_DAILY_amd64_K.iso"
	"Sabayon_Linux_DAILY_x86_K.iso"
	"Sabayon_Linux_DAILY_amd64_LXDE.iso"
	"Sabayon_Linux_DAILY_x86_LXDE.iso"
	"Sabayon_Linux_DAILY_amd64_XFCE.iso"
	"Sabayon_Linux_DAILY_x86_XFCE.iso"
	"Sabayon_Linux_DAILY_amd64_E17.iso"
	"Sabayon_Linux_DAILY_x86_E17.iso"
	"Sabayon_Linux_CoreCDX_DAILY_amd64.iso"
	"Sabayon_Linux_CoreCDX_DAILY_x86.iso"
	"Sabayon_Linux_ServerBase_DAILY_amd64.iso"
	"Sabayon_Linux_ServerBase_DAILY_x86.iso"
	"Sabayon_Linux_Gforensic_DAILY_x86.iso"
	"Sabayon_Linux_Kforensic_DAILY_x86.iso"
	"Sabayon_Linux_DAILY_amd64_Gaming.iso"
	"Sabayon_Linux_DAILY_x86_Gaming.iso"
)

REMASTER_OPENVZ_SPECS=(
	"sabayon-amd64-spinbase-openvz-template.spec"
	"sabayon-x86-spinbase-openvz-template.spec"
)
REMASTER_OPENVZ_SPECS_TAR=(
	"Sabayon_Linux_SpinBase_DAILY_amd64_openvz.tar.gz"
	"Sabayon_Linux_SpinBase_DAILY_x86_openvz.tar.gz"
)

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

		for i in ${!SOURCE_SPECS[@]}
		do
			src="/sabayon/molecules/${SOURCE_SPECS[i]}"
			dst="/sabayon/molecules/daily/${SOURCE_SPECS[i]}"
			cp "${src}" "${dst}" -p || exit 1
			echo >> "${dst}"
			echo "inner_source_chroot_script: /sabayon/scripts/inner_source_chroot_update.sh" >> "${dst}"
			# tweak iso image name
			sed -i "s/^#.*destination_iso_image_name/destination_iso_image_name:/" "${dst}" || exit 1
			sed -i "s/destination_iso_image_name.*/destination_iso_image_name: ${SOURCE_SPECS_ISO[i]}/" "${dst}" || exit 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || exit 1
			echo "${dst}: iso: ${SOURCE_SPECS_ISO[i]} date: ${CUR_DATE}"
		done

		for i in ${!REMASTER_SPECS[@]}
		do
			src="/sabayon/molecules/${REMASTER_SPECS[i]}"
			dst="/sabayon/molecules/daily/remaster/${REMASTER_SPECS[i]}"
			cp "${src}" "${dst}" -p || exit 1
			# tweak iso image name
			sed -i "s/^#.*destination_iso_image_name/destination_iso_image_name:/" "${dst}" || exit 1
			sed -i "s/destination_iso_image_name.*/destination_iso_image_name: ${REMASTER_SPECS_ISO[i]}/" "${dst}" || exit 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || exit 1
			echo "${dst}: iso: ${REMASTER_SPECS_ISO[i]} date: ${CUR_DATE}"
		done

		for i in ${!REMASTER_OPENVZ_SPECS[@]}
		do
			src="/sabayon/molecules/${REMASTER_OPENVZ_SPECS[i]}"
			dst="/sabayon/molecules/daily/remaster/${REMASTER_OPENVZ_SPECS[i]}"
			cp "${src}" "${dst}" -p || exit 1
			# tweak tar name
			sed -i "s/^#.*tar_name/tar_name:/" "${dst}" || exit 1
			sed -i "s/tar_name.*/tar_name: ${REMASTER_OPENVZ_SPECS_TAR[i]}/" "${dst}" || exit 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || exit 1
			echo "${dst}: iso: ${REMASTER_OPENVZ_SPECS_TAR[i]} date: ${CUR_DATE}"
		done

		molecule --nocolor /sabayon/molecules/daily/*.spec && \
			molecule --nocolor /sabayon/molecules/daily/remaster/*.spec && \
			cp /sabayon/iso/*DAILY* /sabayon/iso_rsync/ && \
			( date > /sabayon/iso_rsync/RELEASE_DATE_DAILY ) && \
			/sabayon/scripts/make_torrents.sh
	fi
}

if [ -n "${DO_STDOUT}" ]; then
	build_sabayon && move_to_pkg_sabayon_org
else
	( build_sabayon && move_to_pkg_sabayon_org ) &> "/var/log/molecule/autobuild-${CUR_DATE}-${$}.log"
fi

CUR_DAY=$(date -u +%d)
if [ "${CUR_DAY}" = "01" ]; then
	rm -rf /sabayon/pkgcache/*
fi
