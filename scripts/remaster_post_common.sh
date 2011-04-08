# switch to sabayon-weekly repository if the ISO is not a DAILY one
# BUILDING_DAILY is set in scripts/daily_iso_build.sh
if [ -z "${BUILDING_DAILY}" ]; then
        # only the first occurence
        repo_conf="${CHROOT_DIR}/etc/entropy/repositories.conf"
        sed -i "/^repository =/ s/sabayonlinux.org/sabayon-weekly/" "${repo_conf}" || exit 1
        sed -i "/^officialrepositoryid/ s/sabayonlinux.org/sabayon-weekly/" "${repo_conf}" || exit 1
        sed -i "/^official-repository-id/ s/sabayonlinux.org/sabayon-weekly/" "${repo_conf}" || exit 1
fi
