#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: dd tool with progress
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# dd with progress
VERSION=0.0.1
PROGNAME="$(basename $0)"
export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
cat << EOF
$PROGNAME $VERSION

Usage:
./$PROGNAME [option]
Options
-p dd with progress
--version  Show version
-h --help  Show this usage
EOF
}

if [[ "$1" == ""  ]];then
usage
exit 0
fi

read_fun() {
    read -p "$1" RESPON
    echo $RESPON
}

print_fun() {
    echo "You inputed :" >&1
    echo $1 >&1
    echo "print done"
}

ARGS=( "$@" )

case "$1" in
	-p)
	    sudo dd if=$2 of=$3 bs=$4 status=progress
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
