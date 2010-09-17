#!/bin/bash

source /etc/profile
env-update
source /etc/profile

# Setup environment vars
export ETP_NONINTERACTIVE=1
if [ -d "/usr/portage/licenses" ]; then
	export ACCEPT_LICENSE="$(ls /usr/portage/licenses -1 | xargs)"
fi

export ETP_NOINTERACTIVE=1
export FORCE_EAPI=2
equo update || ( sleep 1200 && equo update ) || exit 1
equo upgrade || exit 1
echo "-5" | equo conf update
rm -rf /var/lib/entropy/client/packages

equo query list installed -qv > /etc/sabayon-pkglist
