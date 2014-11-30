#!/bin/sh

/usr/sbin/env-update
. /etc/profile

safe_run() {
	local updated=0
	for ((i=0; i < 42; i++)); do
		"${@}" && {
			updated=1;
			break;
		}
		if [ ${i} -gt 6 ]; then
			sleep 3600 || return 1
		else
			sleep 1200 || return 1
		fi
	done
	if [ "${updated}" = "0" ]; then
		return 1
	fi
	return 0
}

# make sure there is no stale pid file around that prevents entropy from running
rm -f /var/run/entropy/entropy.lock

# disable all mirrors but GARR
for repo_conf in /etc/entropy/repositories.conf.d/entropy_*; do
	# skip .example files
	if [[ "${repo_conf}" =~ .*\.example$ ]]; then
		echo "skipping ${repo_conf}"
		continue
	fi
	sed -n -e "/^pkg = .*pkg.sabayon.org/p" -e "/^repo = .*pkg.sabayon.org/p" \
		-e "/garr.it/p" -e "/^\[.*\]$/p" -i "${repo_conf}"
done

FORCE_EAPI=2 safe_run equo update || exit 1
