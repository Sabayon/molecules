#!/bin/sh
# Remove tarballs not accessed in the last 30 days
# concurrency wrt scripts is handled in crontab

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"

DIR="${SABAYON_MOLECULE_HOME}/pkgcache"
find "${DIR}" -atime +30 -type f -delete
