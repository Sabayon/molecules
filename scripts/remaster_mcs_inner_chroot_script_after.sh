#!/bin/sh

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

# temp jboss-bin fixes
useradd jboss
chown jboss:jboss /opt/jboss-bin-4.2 -R

# setup fqdn
sed -i 's/sabayon/localhost.localdomain sabayon/g' /etc/hosts

# setup MySQL
mysql_ebuild="$(find /var/db/pkg/dev-db -name "mysql*.ebuild" | sort | head -n 1)"
if [ -z "${mysql_ebuild}" ]; then
	echo "cannot find any mysql ebuild"
	exit 1
fi
echo "password=mcsmanager" > /root/.my.cnf || exit 1
mount -t tmpfs none /var/run/mysqld
ebuild "${mysql_ebuild}" config
if [ "${?}" != "0" ]; then
	umount /var/run/mysqld
	exit 1
fi
rm /root/.my.cnf -f
umount /var/run/mysqld
# setup password
sed -i '/^#password/ s/your_password/mcsmanager/g' /etc/mysql/my.cnf || exit 1
sed -i '/^#password/ s/#//g' /etc/mysql/my.cnf || exit 1

# FIXME: enable mysql InnoDB?

# setup 389-console data
mkdir /etc/skel/.389-console
echo "UserID=admin
HostURL=http\://localhost\:9830
" > /etc/skel/.389-console/Console.1.1.5.Login.preferences

# add services to init
rc-update add 389-ds default
rc-update add 389-admin default
rc-update add 389-ds-snmp default
rc-update add jboss-bin-4.2 default
rc-update add mysql default

# remove unused services from init
rc-update del sabayon-mce default
rc-update del sabayon-mce boot
rc-update del music default

# Sabayon stuff

echo -5 | equo conf update
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

