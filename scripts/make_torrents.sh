#!/bin/sh

/usr/sbin/env-update && source /etc/profile

announce_url="http://tracker.sabayon.org/tracker.php/announce"
iso_dir="/sabayon/iso"
cd "${iso_dir}"

for iso_file in "${iso_dir}"/*.{iso,tar.gz}; do
	iso_name="${iso_file/.iso}"
	iso_name="${iso_name/.tar.gz}"
	torrent_file="${iso_file}.torrent"
	[[ -f "${torrent_file}" ]] && rm "${torrent_file}"
	iso_file_name="$(basename ${iso_file})"
	mktorrent-borg -nd -a "${announce_url}" -n "${iso_name}" -o "${torrent_file}" "${iso_file_name}" || exit 1
done
