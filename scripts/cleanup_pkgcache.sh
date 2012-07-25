#!/bin/sh
# Remove tarballs not accessed in the last 30 days
# concurrency wrt scripts is handled in crontab

DIR="/sabayon/pkgcache"
find "${DIR}" -atime +30 -type f -delete
