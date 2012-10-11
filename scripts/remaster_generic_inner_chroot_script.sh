#!/bin/sh

/usr/sbin/env-update
. /etc/profile

# make sure there is no stale pid file around that prevents entropy from running
rm -f /var/run/entropy/entropy.lock

export FORCE_EAPI=2
updated=0
for ((i=0; i < 42; i++)); do
	equo update && {
		updated=1;
		break;
	}
	if [ ${i} -gt 6 ]; then
		sleep 3600 || exit 1
	else
		sleep 1200 || exit 1
	fi
done
if [ "${updated}" = "0" ]; then
	exit 1
fi

# disable all mirrors but GARR
for repo_conf in /etc/entropy/repositories.conf /etc/entropy/repositories.conf.d/entropy_*; do
	# skip .example files
	if [[ "${repo_conf}" =~ .*\.example$ ]]; then
		echo "skipping ${repo_conf}"
		continue
	fi
	sed -n -e "/pkg.sabayon.org/p" -e "/garr.it/p" -e "/^branch/p" \
		-e "/^product/p" -e "/^official-repository-id/p" -e "/^differential-update/p" \
		-i "${repo_conf}"
done
