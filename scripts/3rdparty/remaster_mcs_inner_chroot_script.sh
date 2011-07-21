#!/bin/sh

env-update
source /etc/profile

export FORCE_EAPI=2
equo update
if [ "${?}" != "0" ]; then
        sleep 1200 || exit 1
        equo update || exit 1
fi

# unmask apache with worker MPM
equo unmask www-servers/apache[threads]
# mask regular one
equo mask www-servers/apache[-threads]

# better installing sun-jdk here, to make packages_to_install happy
equo install sun-jdk
java-config -S sun-jdk
env-update
