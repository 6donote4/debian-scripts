#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Resolve information of url about ss,ssr, vmess
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# Resolve information of url about ss,ssr,vmess.
VERSION=0.0.1
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
#args=($(getopt -o s:S:V:vh -l help,version -- "$@"))
#set -- "$args";
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
-s Resolve ss url
-S Resolve SSR url
-V Resolve vmess url
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

main(){
    usage
}

while [ -n "$1" ]
do
	case "$1" in
        -s)
	       echo $2 > tmp.url
	       cut tmp.url -c 6- > tmp.json
	       base64 --decode tmp.json > config.json
	       rm tmp.url tmp.json
            exit 0
            ;;
        -S)
	       echo $2 > tmp.url
	       cut tmp.url -c 7- > tmp.json
	       base64 --decode tmp.json > config.json
	       rm tmp.url tmp.json
            exit 0
            ;;
        -V)
	       echo $2 > tmp.url
	       cut tmp.url -c 10- > tmp.json
	       base64 --decode tmp.json > info.json
	       rm tmp.url tmp.json

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
