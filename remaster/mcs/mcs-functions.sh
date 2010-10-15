#!/bin/bash

setup_fds() {
	# setup 389-ds
	tmp_config_file="$(mktemp)"
	echo "[General]
FullMachineName=sabayon
SuiteSpotUserID=dirsrv
SuiteSpotGroup=dirsrv
ConfigDirectoryAdminPwd=mcsmanager
AdminDomain=sabayon

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
	# FIXME: calling the script directly, from init, won't work, WTF!
	su - -c "/usr/sbin/setup-ds-admin.pl -f ${tmp_config_file} --silent" || return 1
	echo "389 Directory Server configured."
	/etc/init.d/389-ds stop --nodeps &> /dev/null
	/etc/init.d/389-admin stop --nodeps &> /dev/null
	return 0
}
