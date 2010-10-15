#!/bin/sh
export FORCE_EAPI=2
equo update || ( sleep 1200 && equo update ) || exit 1

# unmask apache with worker MPM
equo unmask www-servers/apache[threads]
