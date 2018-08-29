#!/bin/bash

TARGET="${1}"

/usr/sbin/env-update
. /etc/profile

# Setup environment vars
export ACCEPT_LICENSE=*

export SABAYON_INSTALL_KERNEL="${SABAYON_INSTALL_KERNEL:-0}"

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

# Add additional enman repositories:
# For customized images
if [ -n "${SABAYON_ENMAN_REPOS}" ] ; then
  safe_run equo i app-admin/enman || exit 1

  for repos in ${SABAYON_ENMAN_REPOS} ; do
    echo "Adding enman repos ${repos}..."
    safe_run enman add ${repos} || exit 1
  done
fi

FORCE_EAPI=2 safe_run equo update || exit 1

for repo in $(equo repo list -q); do
  echo "Optimizing mirrors for ${repo}"
  equo repo mirrorsort "${repo}"  # ignore errors
done

safe_run equo upgrade --fetch || exit 1
equo upgrade --purge || exit 1


# FIXME: Dup in iner_chroot_script.sh
# We need plymouth before
equo i sys-boot/plymouth x11-themes/sabayon-artwork-plymouth-default

echo "PLYMOUTH THEME LIST:"
plymouth-set-default-theme --list
# Set Plymouth default theme, newer artwork has the sabayon theme
is_ply_sabayon=$(plymouth-set-default-theme --list | grep sabayon)
if [ -n "${is_ply_sabayon}" ]; then
	plymouth-set-default-theme sabayon
else
	plymouth-set-default-theme solar
fi

equo remove "${PACKAGES_TO_REMOVE[@]}" # ignore
echo "-5" | equo conf update

if [[ ${SABAYON_INSTALL_KERNEL} -eq 1 ]] ; then
  # check if a kernel update is needed
  kernel_target_pkg="$(equo match -q --installed virtual/linux-binary)"
  current_kernel=$(equo match --installed "${kernel_target_pkg}" -q --showslot)

  echo "Move to kernel ${kernel_target_pkg}:${SABAYON_KERNEL_VERSION}"
  # Do not pick for now latest kernel, but fix it to 4.14
  #available_kernel=$(equo match "${kernel_target_pkg}" -q --showslot)
  available_kernel="sys-kernel/linux-sabayon:${SABAYON_KERNEL_VERSION}"

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
fi

# Unmask packages (used on custom ISO)
if [ -n "${SABAYON_UNMASK_PKGS}" ] ; then
  touch /etc/entropy/packages/package.unmask
  equo unmask ${SABAYON_EXTRA_PKGS}
fi

# Add custom packages required from user for source rootfs.
if [ -n "${SABAYON_EXTRA_PKGS}" ] ; then
  safe_run equo i ${SABAYON_EXTRA_PKGS[@]}
fi

# keep /lib/modules clean at all times
for moddir in $(find /lib/modules -maxdepth 1 -type d -empty); do
  echo "Cleaning ${moddir} because it's empty"
  rmdir "${moddir}"
done

rm -rf /var/lib/entropy/client/packages

# copy Portage config from sabayonlinux.org entropy repo to system
for conf in package.mask package.unmask package.keywords make.conf package.use; do
  repo_path=/var/lib/entropy/client/database/*/sabayonlinux.org/standard
  repo_conf=$(ls -1 ${repo_path}/*/*/${conf} | sort | tail -n 1 2>/dev/null)
  if [ -n "${repo_conf}" ]; then
    target_path="/etc/portage/${conf}"
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

if [ -n "${DRACUT}" ]; then
  # Dracut initramfs generation for livecd
  # XXX: If you are reading this ..beware!
  # this step should be re-done by Installer post-install,
  # without the options needed to boot from live! (see kernel eclass for reference)
  current_kernel=$(equo match --installed "sys-kernel/linux-sabayon" -q --showslot)

  #ACCEPT_LICENSE=* equo upgrade # upgrading all. this ensures that minor kernel upgrades don't breaks dracut initramfs generation
  # Getting Package name and slot from current kernel (e.g. current_kernel=sys-kernel/linux-sabayon:4.7 -> K_SABKERNEL_NAME = linux-sabayon-4.7 )
  PN=${current_kernel##*/}
  K_SABKERNEL_NAME="${K_SABKERNEL_NAME:-${PN/${PN/-/}-}}"
  K_SABKERNEL_NAME="${K_SABKERNEL_NAME/:/-}"

  # Grab kernel version from RELEASE_LEVEL
  kver=$(cat /etc/kernels/$K_SABKERNEL_NAME*/RELEASE_LEVEL)
  karch=$(uname -m)
  echo "Generating dracut for kernel $kver arch $karch"
  dracut -N -a dmsquash-live -a pollcdrom \
         --force --kver=${kver} /boot/initramfs-genkernel-${karch}-${kver}
fi

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
