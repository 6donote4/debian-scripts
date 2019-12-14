#!/bin/sh
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Delete some files in Linux
#   Version: 0.0.2
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# This script is used to delete selected files in Linux
VERSION=0.0.2
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
-s  Delete specified files in specified size
-e  Delete empty directory
-n  Delete files of specified name in limited size 
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

while [[ -n "$1" ]]; 
do
	case "$1" in
           -s)
#			read -p "Please input file name:" FILENAME
#			echo "filename = $FILENAME "
			echo
                        read -p "Please input file size:" FILESIZE
                        echo "filesize = $FILESIZE "
                        echo
                        read -p "Please input max directory depth:" DEPTH
                        echo "filedepth = $DEPTH "
                        echo
			find . -maxdepth $DEPTH -size -$FILESIZE ! -iname '*.sh' -type f -exec ls {} \;
		       # find . -maxdepth $DEPTH -size -$FILESIZE  -iname "$FILENAME" -exec ls {} \;
                        find . -maxdepth $DEPTH -size -$FILESIZE ! -iname '*.sh' -type f -delete 
                       # find . -maxdepth $DEPTH -size -$FILESIZE  -iname "$FILENAME" -delete
	                echo "done"
	                exit 0
			;;
          -n)
			read -p "Please input file name:" FILENAME
			echo "filename = $FILENAME "
			echo
                        read -p "Please input file size:" FILESIZE
                        echo "filesize = $FILESIZE "
                        echo
                        read -p "Please input max directory depth:" DEPTH
                        echo "filedepth = $DEPTH "
                        echo
			find . -maxdepth $DEPTH -size -$FILESIZE -iname "$FILENAME" ! -iname '*.sh' -type f -exec ls {} \;
                        find . -maxdepth $DEPTH -size -$FILESIZE -iname "$FILENAME" ! -iname '*.sh' -type f -delete 
	                echo "done"
	                exit 0
			;;
 

	    -e)  
			find . -empty -delete
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
