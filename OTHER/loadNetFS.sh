#!/bin/sh
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Mount network file by nfs 
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# Mount network file by nfs
VERSION=0.0.1
PROGNAME="$(basename $0)"
MOUNTPATH="127.0.0.1:/home"
MOUNTFILE="asusbox"
export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
cat << EOF
$PROGNAME $VERSION

Usage:
./$PROGNAME [option]
Options
-m Mount network file 
-u Unmount network file
-q Query network file
--version  Show version
-h --help  Show this usage
EOF
}

if [[ "$1" == ""  ]];then
usage
exit 0
fi

_mount() {
mount.nfs $MOUNTPATH $MOUNTFILE
}

_umount() {
umount.nfs $MOUNTPATH $MOUNTFILE
}

_query() {
read -p "Please input a host to query a file path:" HOSTIP
showmount -e $HOSTIP
}

ARGS=( "$@" )

case "$1" in
	-m)
		_mount
		exit 0
		;;
	-u)
		_umount
		exit 0
		;;
	-q)
		_query
		exit 0
		;;
	-h|--help)
		usage
		exit 0
		;;
	--version)
		echo $VERSION
		exit 0
		;;
	*)
		echo  "Invalid parameter $1" 1>&2
		exit 1
		;;
esac

