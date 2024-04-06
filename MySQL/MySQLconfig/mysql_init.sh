#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
PROGRAM=$0
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl enable mysqld
systemctl start mysqld
exit 0
