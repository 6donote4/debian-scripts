#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Shutdown on schedule
#   Version: 0.0.5
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# This script is used to shitdown
VERSION=0.0.5
PROGNAME="$(basename $0)"

export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
cat << EOF
delfiles $VERSION

Usage:
./$PROGNAME [option]
Options
-s  Shutdown
--version  Show version
-h --help  Show this usage
EOF
}

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

ARGS=( "$@" )

	case "$1" in
           -s)
               read -p "Please input poweroff time (HH:mm):" OFFTIME
               echo "poweroff time = $OFFTIME "
               echo
               sudo shutdown -P $OFFTIME
               exit 0
               ;;
           -c)
               sudo shutdown -P $2
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
