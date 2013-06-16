#!/bin/bash

/usr/sbin/env-update
. /etc/profile

. /mkloopcard_chroot.include || exit 1

setup_boot
setup_users

exit 0
