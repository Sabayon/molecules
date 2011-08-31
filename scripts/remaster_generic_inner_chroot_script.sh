#!/bin/sh

# make sure there is no stale pid file around that prevents entropy from running
rm -f /var/run/entropy/entropy.lock

export FORCE_EAPI=2
equo update
if [ "${?}" != "0" ]; then
        sleep 1200 || exit 1
        equo update || exit 1
fi

# disable all mirrors but GARR
sed -n -e "/pkg.sabayon.org/p" -e "/garr.it/p" -e "/^branch/p" \
	-e "/^product/p" -e "/^official-repository-id/p" -e "/^differential-update/p" \
	-i /etc/entropy/repositories.conf
