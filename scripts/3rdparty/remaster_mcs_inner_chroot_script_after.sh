#!/bin/sh

env-update
source /etc/profile

# merge config updates first
echo -5 | equo conf update

# make sure that sun-jdk is in use
java-config -S sun-jdk || exit 1

# setup Desktop icons
rm /etc/skel/Desktop/*.desktop
cp /usr/share/applications/keyboard.desktop /etc/skel/Desktop/ -p
cp /usr/share/applications/389-console*.desktop /etc/skel/Desktop/ -p
chown root:root /etc/skel/Desktop -R

# Setup init scripts
cp /.mcs/mcs-functions.sh /sbin/mcs-functions.sh
chmod 755 /sbin/mcs-functions.sh
chown root:root /sbin/mcs-functions.sh
cp /.mcs/mcs-oemsystem-default /etc/init.d/oemsystem-default
chmod 755 /etc/init.d/oemsystem-default
chown root:root /etc/init.d/oemsystem-default
rc-update add oemsystem-default default

# setup fqdn
sed -i 's/sabayon/localhost.localdomain sabayon/g' /etc/hosts
sed -i 's/sabayon/localhost.localdomain/g' /etc/conf.d/hostname
# setup fqdn in 389-admin, stop annoying apache crap
sed -i '/^#ServerName/ s/.*/ServerName localhost.localdomain/g' /etc/dirsrv/admin-serv/httpd.conf || exit 1

# setup MySQL
# Fixup mysqld permissions, ebuild bug?
chown mysql:mysql /var/run/mysqld -R

mysql_ebuild="$(find /var/db/pkg/dev-db -name "mysql*.ebuild" | sort | head -n 1)"
if [ -z "${mysql_ebuild}" ]; then
	echo "cannot find any mysql ebuild"
	exit 1
fi
echo "password=mcsmanager" > /root/.my.cnf || exit 1
HOSTNAME="somethingelse" ebuild "${mysql_ebuild}" config
if [ "${?}" != "0" ]; then
	exit 1
fi
rm /root/.my.cnf -f
# setup password
sed -i '/^#password/ s/your_password/mcsmanager/g' /etc/mysql/my.cnf || exit 1
sed -i '/^#password/ s/#//g' /etc/mysql/my.cnf || exit 1

# start and insert data
echo "Setting up mysql"
/etc/init.d/mysql start --nodeps || exit 1
mysql -u root --password=mcsmanager -h localhost < /.mcs/mwsql.sql
mysql -u root --password=mcsmanager -h localhost < /.mcs/bedework.sql
/etc/init.d/mysql stop --nodeps

# setup 389-console data
mkdir /etc/skel/.389-console
echo "UserID=admin
HostURL=http\://localhost\:9830
" > /etc/skel/.389-console/Console.1.1.5.Login.preferences

# Setup Postfix
echo "Setting up Postfix"
cp /.mcs/postfix/main.cf /etc/postfix/main.cf || exit 1
cp /.mcs/postfix/master.cf /etc/postfix/master.cf || exit 1
cp /.mcs/postfix/ldapconf /etc/postfix/ldapconf -Rp || exit 1
chown root:root /etc/postfix/{main,master}.cf || exit 1
chmod 644 /etc/postfix/{main,master}.cf || exit 1
chmod 755 /etc/postfix/ldapconf || exit 1
chmod 644 /etc/postfix/ldapconf/*.cf || exit 1
chown root:root /etc/postfix/ldapconf -R || exit 1
# mmt_scripts
cp /.mcs/mmt_scripts /usr/local/ -Rp || exit 1
chown root:root /usr/local/mmt_scripts -R || exit 1
chmod 755 /usr/local/mmt_scripts/* -R || exit 1

# temp unpack jboss-deploy.tar.bz2
echo "Unpacking jboss-deploy data"
tar xjf /.mcs/jboss-deploy.tar.bz2 -C /tmp || exit 1
jboss_deploy="/tmp/jboss-deploy"
if [ ! -d "${jboss_deploy}" ]; then
	echo "${jboss_deploy} not a dir"
	exit 1
fi

# copy mcs-ldapinit.pl somewhere, it will be used to setup mcs ldap schema at runtime
cp /.mcs/scripts/mcs-ldapinit.pl /usr/sbin/ || exit 1
chmod +x /usr/sbin/mcs-ldapinit.pl || exit 1
chown root:root /usr/sbin/mcs-ldapinit.pl || exit 1

## Setup MCS

# copy jboss data over
echo "Copying jboss-bin deploy data over"
mv /tmp/jboss-deploy/* /opt/jboss-bin-4.2/server/default/deploy/ || exit 1
chown jboss:jboss /opt/jboss-bin-4.2/server/default/deploy/ -R || exit 1

# setup 389 schema
cp /.mcs/389-mailware-schema/* /etc/dirsrv/schema/ || exit 1
chown root:root /etc/dirsrv/schema/*.ldif -R || exit 1

# setup config
cp /.mcs/mailware-sabayon-conf/web/WEB-INF/balance.xml /opt/jboss-bin-4.2/server/default/deploy/MailWare-Manager.war/WEB-INF/balance.xml || exit 1
cp /.mcs/mailware-sabayon-conf/web/WEB-INF/conf/axis2.xml /opt/jboss-bin-4.2/server/default/deploy/MailWare-Manager.war/WEB-INF/conf/axis2.xml || exit 1

mkdir /maildirs || exit 1
chown mail:mail /maildirs -R || exit 1

# Setup dovecot
cp /.mcs/dovecot*.conf /etc/dovecot/ || exit 1
chown root:root /etc/dovecot/dovecot*.conf || exit 1
chmod 644 /etc/dovecot/dovecot*.conf || exit 1

# add services to init
# autostarted by the mcs setup script
## rc-update add 389-ds default
## rc-update add 389-admin default
rc-update add 389-ds-snmp default
rc-update add jboss-bin-4.2 default
rc-update add mysql default
rc-update add dovecot default
rc-update add postfix default
rc-update add ejabberd default

# remove unused services from init
rc-update del sabayon-mce default
rc-update del sabayon-mce boot
rc-update del music default

# remove temp .mcs dir
rm /.mcs -rf

# Sabayon stuff
echo "Working out Sabayon stuff"
rm -rf /install-data || exit 1
rm -rf /usr/share/sabayon/xdg || exit 1
rm -rf /usr/share/applications/sabayon-*.desktop

mount -t proc proc /proc
/lib/rc/bin/rc-depend -u

echo "Vacuum cleaning client db"
rm /var/lib/entropy/client/database/*/sabayonlinux.org -rf
equo rescue vacuum

# cleanup log dir
rm /var/lib/entropy/logs -rf

# Generate openrc cache
/etc/init.d/savecache start
/etc/init.d/savecache zap

ldconfig
ldconfig
umount /proc

equo deptest --pretend
emaint --fix world

# remove non-interactive settings
rm /etc/env.d/00mcs-etp-noninteractive -f

rm -rf /var/lib/entropy/*cache*

