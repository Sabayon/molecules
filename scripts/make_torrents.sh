#!/bin/bash

/usr/sbin/env-update
. /etc/profile

# Path to molecules.git dir. I try to use SABAYON_MOLECULES_DIR from sabayon_molecules.sh script.
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULES_DIR:-${SABAYON_MOLECULE_HOME:-/sabayon}}"
export SABAYON_MOLECULE_HOME

SABAYON_TORRENT_ANNOUNCE_URL="${SABAYON_TORRENT_ANNOUNCE_URL:-http://torrents.sabayon.org:8082/announce}"

# Use SABAYON_MOLECULES_ISO from sabayon_molecules.sh script (docker-isobuilder)
SABAYON_MOLECULES_ISO="${SABAYON_MOLECULES_ISO:-${SABAYON_MOLECULE_HOME}/iso}"

echo "==========================================================="
echo "Torrent Announce URL: ${SABAYON_TORRENT_ANNOUNCE_URL}"
echo "==========================================================="

pushd ${SABAYON_MOLECULES_ISO}

  for iso_file in ${SABAYON_MOLECULES_ISO}/*.{iso,tar.gz,tar.xz}; do

    if [ ! -e "${iso_file}" ]; then
      echo "${iso_file} does not exist, skipping..."
      continue
    fi

    iso_name="${iso_file/.iso}"
    iso_name="${iso_name/.tar.gz}"
    iso_name="${iso_name/.tar.xz}"

    torrent_file="${iso_file}.torrent"
    [[ -f "${torrent_file}" ]] && rm "${torrent_file}"
    iso_file_name="$(basename ${iso_file})"
    echo "Cooking ${iso_file_name}"
    mktorrent-borg -pub -nd \
      -a "${SABAYON_TORRENT_ANNOUNCE_URL}" -n "${iso_name}" \
      -o "${torrent_file}" "${iso_file_name}" || exit 1
  done

popd

exit 0
