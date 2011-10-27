# switch to sabayon-weekly repository if the ISO is not a DAILY one
# BUILDING_DAILY is set in scripts/daily_iso_build.sh
if [ -z "${BUILDING_DAILY}" ]; then
        # only the first occurence
        repo_conf="${CHROOT_DIR}/etc/entropy/repositories.conf"
        sed -i "/^officialrepositoryid/ s/sabayonlinux.org/sabayon-weekly/" "${repo_conf}" || exit 1
        sed -i "/^official-repository-id/ s/sabayonlinux.org/sabayon-weekly/" "${repo_conf}" || exit 1
        sed -i "/^repository =/ s/sabayonlinux.org/sabayon-weekly/" "${repo_conf}" || exit 1
	# new style repository config files (inside repositories.conf.d/ directory)
	repo_conf_d="${CHROOT_DIR}/etc/entropy/repositories.conf.d"
	src_conf="${repo_conf_d}/entropy_sabayonlinux.org"
	dst_conf="${repo_conf_d}/entropy_sabayon-weekly"
	if [ -f "${src_conf}" ]; then
		mv "${src_conf}" "${dst_conf}" || exit 1
		sed -i "/^repository =/ s/= sabayonlinux.org/= sabayon-weekly/" "${dst_conf}" || exit 1
	fi
fi

# remove entropy hwash
rm -f "${CHROOT_DIR}"/etc/entropy/.hw.hash
# remove entropy pid file
rm -f "${CHROOT_DIR}"/var/run/entropy/entropy.lock

# do not exit!! this file is sourced!
