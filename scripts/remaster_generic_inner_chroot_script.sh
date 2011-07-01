#!/bin/sh
export FORCE_EAPI=2
equo update || ( sleep 1200 && equo update ) || exit 1

# disable all mirrors but GARR
sed -n -e "/pkg.sabayon.org/p" -e "/garr.it/p" -e "/^branch/p" \
	-e "/^product/p" -e "/^official-repository-id/p" -e "/^differential-update/p" \
	-i /etc/entropy/repositories.conf
