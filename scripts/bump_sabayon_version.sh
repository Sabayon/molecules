#!/bin/bash
#
# This script automatically bumps the version of Sabayon
# ebuilds.

. /etc/profile

if [ ${#} -lt 1 ]; then
    echo "${0} <version>" >&2
    exit 1
fi

VERSION="${1}"
OVERLAY_BASE_URL="git+ssh://git@git.sabayon.org/~git/projects/overlays"
OVERLAY_BASE_DIR="${SABAYON_MOLECULE_HOME:-${HOME}}"

PACKAGES=(
    "app-misc/sabayon-version sabayon"
)


pull_overlay() {
    local overlay_dir="${1}"
    local overlay="${2}"
    local overlay_url="${OVERLAY_BASE_URL}/${overlay}.git"
    if [ ! -d "${overlay_dir}" ]; then
        git clone "${overlay_url}" "${overlay_dir}" || return 1
    else
        ( cd "${overlay_dir}" && git pull --rebase ) || return 1
    fi
}

bump_package() {
    local overlay_dir="${1}"
    local overlay="${2}"
    local package="${3}"
    local version="${4}"
    local package_name=$(basename "${package}")
    local skel_file="${package_name}.skel"
    local package_file="${package_name}-${version}.ebuild"

    (
        cd "${overlay_dir}/${package}" || exit 1
        cp "${skel_file}" "${package_file}" || exit 1
        ebuild "${package_file}" manifest || exit 1
        git add "${package_file}" || exit 1
        git add -u . || exit 1
        git commit -m "[${package}] automatic version bump to ${version}" \
            || exit 1

        local done=0
        for x in $(seq 5); do
            git push && {
                done=1;
                break;
            }
            pull_overlay "${overlay_dir}" "${overlay}"
            sleep 5
        done
        if [ "${done}" = "0" ]; then
            echo "Unable to push, giving up after 5 tries" >&2
            echo "Please bump ${package} manually to ${version}" >&2
            exit 1
        fi
    ) || return 1
}


bumped=()
for info in "${PACKAGES[@]}"; do
    data=( ${info} )
    package="${data[0]}"
    bumped+=( "${package}" )
    overlay="${data[1]}"
    overlays_dir="${OVERLAY_BASE_DIR}/automatic-overlays"
    overlay_dir="${overlays_dir}/${overlay}"

    mkdir -p "${overlays_dir}" || exit 1
    pull_overlay "${overlay_dir}" "${overlay}" || exit 1
    bump_package "${overlay_dir}" "${overlay}" "${package}" \
        "${VERSION}" || exit 1
done

echo "The following packages have been updated to version: ${VERSION}" >&2
echo "${bumped[@]}" >&2
echo >&2
echo "Make sure to have these packages bumped in Entropy as soon as possible." >&2
exit 0
