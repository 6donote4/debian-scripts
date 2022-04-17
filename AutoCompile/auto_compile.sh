#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:This script is used to compile C soure program.
#   Version: 0.0.1
#   Blog: https://www.donote.ml https://6donote4.github.io
#========================================
#
VERSION=0.0.1
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
args=($(getopt -o cpvh -l help,version -- "$@"))
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
-c compile program.
--
-p preparation before compiling
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

prepare_fun(){
    autoscan
    mv configure.scan configure.ac
    sed -i '5 a AM_INIT_AUTOMAKE' configure.ac
    print_fun ${FULL_PACKAGE_NAME=$(read_fun "Please input full package name:")}
    print_fun ${PACKAGE_VERSION=$(read_fun "Please input version:")}
    print_fun ${BUG_REPORT_ADDRESS=$(read_fun "Please input email address:")}
    sed -i "4 c AC_INIT($FULL_PACKAGE_NAME, [$PACKAGE_VERSION], [$BUG_REPORT_ADDRESS])" configure.ac
    sed -i "5 d" configure.ac
}

compile_fun() {
    touch AUTHORS NEWS README ChangeLog
    mkdir -m 765 autom4te.cache
    autoheader
    aclocal
    autoconf
    automake --add-missing
    autoupdate
    automake
}

main(){
    usage
}

while [ -n "$1" ]
do
	case "$1" in
        -c)
            compile_fun
            /bin/bash configure
            make
            exit 0
            ;;
        -p)
            prepare_fun
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
            echo -e "${red}Please complete preparation before compiling $1 ${plain}" 1>&2
            break
            ;;
	esac
    shift
done
