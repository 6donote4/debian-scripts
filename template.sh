#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#
VERSION=0.0.1
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
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
-s --
--version  Show version
-h --help  Show this usage
EOF
}

read_fun() {
        read -p "$1" RESPON

            echo $RESPON
        }

print_fun() {
        echo -e "${yellow}You inputed :${plain}"
        echo $1 >&1
        echo -e "${green}print done${plain}"
        }

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

test_fun() {
    print_fun ${ARG=$(read_fun "read_print_test:" )}
    echo -e "${green}test done${plain}"
}

function os_init (){
    select option in "Arch/pacman" "Debian/apt" "CentOS/yum"  "Fedora/dnf" "Exit"
    do
        case $option in
            "Arch/pacman")
                yes|pacman -S dialog ;;
            "Debian/apt")
                apt-get install -y dialog ;;
            "CentOS/yum")
                yum install -y dialog ;;
            "Fedora/dnf")
                dnf install -y dialog ;;
            "Exit")
                clear
                break ;;
            *)
                echo -e "${red}Invalid parameter $1 ${plain}" 1>&2
                exit 1
        esac
    done
    clear
}

#msg title message height width
function msg(){
    dialog --title $1 --msgbox $2 $3 $4
}

#yesno title yesno_question height width
function yesno()
{
    dialog --title $1 --yesno $2 $3 $4
    echo $?
}

#input message height width fileOroutput
function input()
{
    dialog --inputbox $1 $2 $3 > $4
    $?
}

#text textfile height width
function text()
{
    dialog --textbox $1 $2 $3
}
#menu title height width item_sum 1 "item_one" ....
function menu()
{
    dialog --menu "$@"
}
#fselect title height width
function fselect(){
    dialog --title $1 --fselect $HOME/ $2 $3
}

function main(){
    if command -v dialo >/dev/null 2>&1; then
        sleep 4
    else
        os_init
    fi
}


ARGS=( "$@" )

	case "$1" in
        -t)
            fselect "Selectafile:" 40 50
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
            echo -e "${red}Invalid parameter $1 ${plain}" 1>&2
            exit 1
            ;;
	esac

