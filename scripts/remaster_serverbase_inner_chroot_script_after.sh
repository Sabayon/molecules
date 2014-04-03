#!/bin/bash

/usr/sbin/env-update
. /etc/profile

sd_enable() {
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload -f enable "${1}.service"
}

sd_disable() {
	[[ -x /usr/bin/systemctl ]] && \
		systemctl --no-reload -f disable "${1}.service"
}

sd_disable installer-gui
sd_disable avahi-daemon

# install-data dir is really not needed
rm -rf /install-data

ldconfig

emaint --fix world

rm -rf /var/lib/entropy/*cache*

exit 0
