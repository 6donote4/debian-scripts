#!/bin/sh
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Backup files
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
VERSION=0.0.1
PROGNAME="$(basename $0)"

export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
cat << EOF
$PROGNAME $VERSION

Usage:
./$PROGNAME [option] SRC DST
Options
-s --rsync 增量备份，从源目录备份到目标目录，目录名称不可包含目录符号
--version  Show version
-h --help  Show this usage
      
EOF
}

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi
 
ARGS=( "$@" )

while [[ -n "$1" ]]; 
do
	case "$1" in
	    -s|--rsync)
	    	rsync -avz --delete $2 $3
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
