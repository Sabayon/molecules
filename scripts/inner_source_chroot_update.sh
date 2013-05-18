#!/bin/bash

/usr/sbin/env-update
. /etc/profile

# Setup environment vars
export ETP_NONINTERACTIVE=1
if [ -d "/usr/portage/licenses" ]; then
	export ACCEPT_LICENSE="$(ls /usr/portage/licenses -1 | xargs)"
fi

PACKAGES_TO_REMOVE=(
	"app-i18n/man-pages-da"
	"app-i18n/man-pages-de"
	"app-i18n/man-pages-fr"
	"app-i18n/man-pages-it"
	"app-i18n/man-pages-nl"
	"app-i18n/man-pages-pl"
	"app-i18n/man-pages-ro"
	"app-i18n/man-pages-ru"
	"app-i18n/man-pages-zh_CN"
)

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
equo upgrade --purge || exit 1
equo remove "${PACKAGES_TO_REMOVE[@]}" # ignore
echo "-5" | equo conf update

# check if a kernel update is needed
kernel_target_pkg="$(equo match -q --installed virtual/linux-binary)"
current_kernel=$(equo match --installed "${kernel_target_pkg}" -q --showslot)
available_kernel=$(equo match "${kernel_target_pkg}" -q --showslot)
if [ "${current_kernel}" != "${available_kernel}" ] && \
	[ -n "${available_kernel}" ] && [ -n "${current_kernel}" ]; then
	echo
	echo "@@ Upgrading kernel to ${available_kernel}"
	echo
	safe_run kernel-switcher switch "${available_kernel}" || exit 1
	equo remove "${current_kernel}" || exit 1
	# now delete stale files in /lib/modules
	for slink in $(find /lib/modules/ -type l); do
		if [ ! -e "${slink}" ]; then
			echo "Removing broken symlink: ${slink}"
			rm "${slink}" # ignore failure, best effort
			# check if parent dir is empty, in case, remove
			paren_slink=$(dirname "${slink}")
			paren_children=$(find "${paren_slink}")
			if [ -z "${paren_children}" ]; then
				echo "${paren_slink} is empty, removing"
				rmdir "${paren_slink}" # ignore failure, best effort
			fi
		fi
	done
else
	echo "@@ Not upgrading kernels:"
	echo "Current: ${current_kernel}"
	echo "Avail:   ${available_kernel}"
	echo
fi

rm -rf /var/lib/entropy/client/packages

# Make sure that systemd is still the default init system
eselect sysvinit set systemd
eselect settingsd set systemd

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
for conf in 00-sabayon.package.use 00-sabayon.package.mask \
	00-sabayon.package.unmask 00-sabayon.package.keywords; do
	repo_path=/var/lib/entropy/client/database/*/sabayonlinux.org/standard
	repo_conf=$(ls -1 ${repo_path}/*/*/${conf} | sort | tail -n 1 2>/dev/null)
	if [ -n "${repo_conf}" ]; then
		target_path="/etc/portage/${conf/00-sabayon.}/${conf}"
		target_dir=$(dirname "${target_path}")
		if [ -f "${target_dir}" ]; then # remove old file
			rm "${target_dir}" # ignore failure
		fi
		mkdir -p "${target_dir}" # ignore failure
		cp "${repo_conf}" "${target_path}" # ignore

	fi
done

# Update /usr/portage/profiles
# This is actually not strictly needed but several
# gentoo tools expect to find valid /etc/make.profile symlink
# This part is best effort, if it will be able to complete
# correctly, fine.
# For a list of mirrors, see: http://www.gentoo.org/main/en/mirrors-rsync.xml
RSYNC_URI="rsync://rsync.at.gentoo.org/gentoo-portage/profiles"
PROFILES_DIR="/usr/portage/profiles"
safe_run rsync -av -H -A -X --delete-during "${RSYNC_URI}/" "${PROFILES_DIR}/"

equo query list installed -qv > /etc/sabayon-pkglist
