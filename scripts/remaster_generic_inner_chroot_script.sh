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
rm -f /run/entropy/entropy.lock


FORCE_EAPI=2 safe_run equo update || exit 1

for repo in $(equo repo list -q); do
  echo "Optimizing mirrors for ${repo}"
  equo repo mirrorsort "${repo}"  # ignore errors
done

# Add additional enman repositories:
# For customized images
if [ -n "${SABAYON_ENMAN_REPOS}" ] ; then
  safe_run equo i app-admin/enman || exit 1

  for repos in ${SABAYON_ENMAN_REPOS} ; do
    echo "Adding enman repos ${repos}..."
    safe_run enman add ${repos} || exit 1
  done

  FORCE_EAPI=2 safe_run equo update || exit 1
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

exit 0
