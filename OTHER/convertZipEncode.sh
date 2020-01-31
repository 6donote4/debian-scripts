#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Convert GBK to utf8 in zip format archive.
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# This script is used to convert file encode in zip archive.
VERSION=0.0.1
PROGNAME="$(basename $0)"

export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
cat << EOF
delfiles $VERSION

Usage:
./$PROGNAME [option] FILE
Options
-c  Convert file encode
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

preparation() {
    sudo pacman -S 7z convmv ;
}

converts() {

    LANG=C 7za x  \.\/$2;
    convmv -f GBK -t utf8 --notest -r .;
		       }
ARGS=( "$@" )

while [[ -n "$1" ]];
do
	case "$1" in
           -c)
			if [[ -e "/usr/bin/convmv"  &&  -e "/usr/bin/7za" ]] ; then
			    converts
		        else
		            preparation
			fi
	                echo "done"
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
done
