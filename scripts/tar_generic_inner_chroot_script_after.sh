#!/bin/bash

/usr/sbin/env-update && source /etc/profile

# Generate list of installed packages
equo query list installed -qv > /etc/sabayon-pkglist
