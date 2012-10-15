#!/bin/bash

/usr/sbin/env-update
. /etc/profile

# Setup environment vars
export ETP_NONINTERACTIVE=1
if [ -d "/usr/portage/licenses" ]; then
	export ACCEPT_LICENSE="$(ls /usr/portage/licenses -1 | xargs)"
fi

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

export FORCE_EAPI=2
safe_run equo update || exit 1

export ETP_NOINTERACTIVE=1
safe_run equo upgrade --fetch || exit 1
equo upgrade || exit 1
echo "-5" | equo conf update
rm -rf /var/lib/entropy/client/packages

# copy Portage config from sabayonlinux.org entropy repo to system
for conf in package.mask package.unmask package.keywords make.conf package.use; do
	repo_path=/var/lib/entropy/client/database/*/sabayonlinux.org/standard
	repo_conf=$(ls -1 ${repo_path}/*/*/${conf} | sort | tail -n 1 2>/dev/null)
	if [ -n "${repo_conf}" ]; then
		target_path="/etc/portage/${conf}"
		if [ "${conf}" = "make.conf" ]; then
			target_path="/etc/make.conf"
		fi
		if [ ! -d "${target_path}" ]; then # do not touch dirs
			cp "${repo_conf}" "${target_path}" # ignore
		fi
	fi
done

# split config file
for conf in 00-sabayon.package.use; do
	repo_path=/var/lib/entropy/client/database/*/sabayonlinux.org/standard
	repo_conf=$(ls -1 ${repo_path}/*/*/${conf} | sort | tail -n 1 2>/dev/null)
	if [ -n "${repo_conf}" ]; then
		target_path="/etc/portage/${conf/00-sabayon.}/${conf}"
		target_dir=$(dirname "${target_path}")
		if [ -f "${target_dir}" ]; then # remove old file
			rm "${target_dir}" # ignore failure
		fi
		if [ ! -d "${target_path}" ]; then
			mkdir -p "${target_path}" # ignore failure
		fi
		cp "${repo_conf}" "${target_path}" # ignore

	fi
done

equo query list installed -qv > /etc/sabayon-pkglist
