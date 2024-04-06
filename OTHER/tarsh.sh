#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Creating MarkDown code for pictre,video,mp3,etc.
#   Version: 0.0.2
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
./$PROGNAME -c [CompressFileName] [DistDir]
./$PROGNAME -d [CompressFileName]
Options
    -c Creat a bz2 compress file
    -d Decompress a bz2 file
EOF
}

if [[ "$1" == "" ]];then
    usage
    exit 0
fi

ARGS=( "$@" )

while [[ -n "$1" ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --version)
            echo $VERSION
            exit 0
            ;;
        -c)
           tar -cjvf $2.tar.bz2 $3
            exit 0
            ;;
        -d)
           tar -xjvf $2
           exit 0
           ;;
       *)
           echo "Invalid parammeter: $1" 1>&2
           exit 1
           ;;
   esac
done






