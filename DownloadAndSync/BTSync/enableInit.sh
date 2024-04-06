#!/bin/bash
PASSWD="12345"
$USER="user"
THOME="/home/user"
/bin/echo $PASSWD|sudo -S -u $USER /bin/bash $THOME/initAsusBox.sh
exit 0
