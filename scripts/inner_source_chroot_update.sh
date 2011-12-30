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
equo update
if [ "${?}" != "0" ]; then
	sleep 1200 || exit 1
	equo update || exit 1
fi
equo upgrade || exit 1
echo "-5" | equo conf update
rm -rf /var/lib/entropy/client/packages

# Copy updated portage config files to /etc/portage
arch=$(uname -m)
if [ "${arch}" = "x86_64" ]; then
	arch="amd64"
elif [ "${arch}" = "i686" ]; then
	arch="x86"
fi
SABAYON_REPO_DIR="/var/lib/entropy/client/database/${arch}/sabayonlinux.org/standard/${arch}/5"
for cfg in package.mask package.unmask package.keywords package.use make.conf; do
	cfg_path="${SABAYON_REPO_DIR}/${cfg}"
	if [ ! -f "${cfg_path}" ]; then
		continue
	fi

	dest_cfg_path="/etc/portage/${cfg}"
	if [ "${cfg}" = "make.conf" ]; then
		dest_cfg_path="/etc/make.conf"
	fi
	cp "${cfg_path}" "${dest_cfg_path}" # ignore failures
done

equo query list installed -qv > /etc/sabayon-pkglist
