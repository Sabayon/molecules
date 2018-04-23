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

exit 0
