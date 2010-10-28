#!/bin/sh

env-update
source /etc/profile

export FORCE_EAPI=2
equo update || ( sleep 1200 && equo update ) || exit 1

# unmask apache with worker MPM
equo unmask www-servers/apache[threads]
# mask regular one
equo mask www-servers/apache[-threads]

# better installing sun-jdk here, to make packages_to_install happy
equo install sun-jdk
java-config -S sun-jdk
env-update
