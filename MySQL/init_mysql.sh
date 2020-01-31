#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
exit 0
