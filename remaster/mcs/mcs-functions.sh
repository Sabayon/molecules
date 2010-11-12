#!/bin/bash

_is_live() {
	cdroot=$(cat /proc/cmdline | grep cdroot)
	if [ -n "${cdroot}" ]; then
		return 0
	else
		return 1
	fi
}

_is_installer_mode() {
	is_installer=$(cat /proc/cmdline | grep installer)
	if [ -n "${is_installer}" ]; then
		return 0
	else
		return 1
	fi
}

_setup_fds_live() {
	# setup 389-ds
	tmp_config_file="$(mktemp)"
	echo "[General]
FullMachineName=localhost.localdomain
SuiteSpotUserID=dirsrv
SuiteSpotGroup=dirsrv
ConfigDirectoryAdminPwd=mcsmanager

[slapd]
ServerPort=389
ServerIdentifier=sabayon
Suffix=dc=babel,dc=it
RootDN=cn=Directory Manager
RootDNPwd=mcsmanager

[admin]
Port=9830
SysUser=dirsrv
ServerIpAddress=127.0.0.1
ServerAdminID=admin
ServerAdminPwd=mcsmanager
" > "${tmp_config_file}"

	su - -c "/usr/sbin/setup-ds-admin.pl -f ${tmp_config_file} --silent" || return 1

	# init MCS ldap data
	( /usr/sbin/mcs-ldapinit.pl -d localhost.localdomain -b "dc=babel,dc=it" \
		-s sa -p mcsmanager -a node1 -B "db1,db2" -f /tmp/base.ldif ) || return 1
	/usr/bin/ldapmodify -a -D "cn=directory manager" -h localhost -w mcsmanager \
		-f /tmp/base.ldif || return 1

	echo "389 Directory Server configured."
	return 0
}

FDS_SETUP_FILE="/etc/.389-sabayon-configured"

_setup_fds_installed() {
	if [ -e "${FDS_SETUP_FILE}" ]; then
		return
	fi
	# First, setup 389, if not in installer mode
	_is_installer_mode || _setup_fds_live
	# then make it autostart at the next boot
	rc-update add 389-ds default
	rc-update add 389-admin default
	# do the whole thing once
	touch "${FDS_SETUP_FILE}"
}


setup_fds() {
	# setup 389
	if _is_live; then
		_setup_fds_live
	else
		_setup_fds_installed
	fi
}
