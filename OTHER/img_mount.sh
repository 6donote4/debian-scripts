#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:Mount img file to Directory
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#Mount img file to Directory
VERSION=0.0.1
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
args=($(getopt -o mqvh -l help,version -- "$@"))
set -- "$args";
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
usage() {
cat << EOF
$PROGNAME $VERSION
Usage:
./$PROGNAME [option]
Options
-m Mount file to directory
-q Query file partition information
-v --version  Show version
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
        echo -e "${yellow}You inputed :${plain}"
        echo $1 >&1
        echo -e "${green}print done${plain}"
        }

test_fun() {
    print_fun ${ARG=$(read_fun "read_print_test:" )}
    echo -e "${green}test done${plain}"
}

_query() {
   print_fun ${FILENAME=$(read_fun "Please input img file to query information about partition: ")}
   sudo fdisk -l "$FILENAME"
}

_mount() {
    print_fun ${OFFSET=$(read_fun "Please input offset number [Units*Start] : ")}
    print_fun ${IMGFILE=$(read_fun "Please input image file name : ")}
    print_fun ${MOUNTPOINT=$(read_fun "Please input destination to mount  : ")}
    sudo mount -o loop,offset=$OFFSET $IMGFILE $MOUNTPOINT
}

main(){
    usage
}

while [ -n "$1" ]
do
	case "$1" in
        -q)
            _query
            exit 0
            ;;
        -m)
            _mount
            exit 0
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            echo $VERSION
            exit 0
            ;;
        --)
            main
            ;;
        *)
            echo -e "${red}Invalid parameter $1 ${plain}" 1>&2
            break
            ;;
	esac
    shift
done
