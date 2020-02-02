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
args=($(getopt -o stvh -l help,version -- "$@"))
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
-s --
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
        echo -e "${yellow}You inputed :${plain}"
        echo $1 >&1
        echo -e "${green}print done${plain}"
        }

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
                break ;;
                   esac
    done
    clear
}

#msg box_title message_title height width
msg(){
    dialog --title "$1" --msgbox "$2" $3 $4
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}


#yesno box_title yesno_question height width
yesno()
{
    dialog --title "$1" --no-shadow --yesno "$2" $3 $4
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}

#input box_title message height width fileORoutput
input()
{
    dialog --title "$1" --inputbox "$2" $3 $4 2> $5
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}

#text title textfile height width
text()
{
    dialog --title "$1" --textbox "$2" $3 $4
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}
#menu box_title height width item_sum 1 "item_one" ....
menu()
{
    dialog --menu "$@"
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}
#fselect title height width
fselect(){
    one=${1}
    two=${2}
    three=${3}
    shift 3
    dialog --title "${one}" --fselect $HOME/ ${two} ${three}
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}
#passkey title promopt height width
passkey(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    shift 4
    dialog --title "${one}" --insecure  --passwordbox \
        "${two}" ${three} ${four} $@
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}
#checklist backtitle checklist_title height width menu_height tag1_str item1_str item1_posnum......
checklist(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --backtitle "${one}" --checklist "${two}" ${three} ${four} ${five} "$@"
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}
#calc_show height width day month year
calc_show()
{
    one=${1}
    two=${2}
    shift 2
    dialog --title "Calendar" --calendar "Date" ${one} ${two} $@
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi

}
#pro_watch title gauge_info height width [percent]
pro_watch(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --title "${one}" --gauge "${two}" ${three} ${four} ${five} $@
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}
#form title form_title height width formheight \
# [label y x item y x fieldlen inputlen]
form(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --title "${one}" --form "${two}" ${three} ${four} ${five} "$@"
    result=$?
    if [ $result -eq 1 ] ; then
        exit 1;
    elif [ $result -eq 255 ] ; then
        exit 255;
    fi
}


pro_watching(){
    declare -i PERCENT=0
    (
        for i in {1..100} ;
        do
            if [ $PERCENT -le 100 ]; then
                echo $PERCENT
                let PERCENT+=1
            fi
            sleep 0.1
        done
    )|pro_watch "installation" "installing..." 10 20 0
}

main(){
    if command -v dialog >/dev/null 2>&1; then
            form "Add a user" "Please input the infomation of new user:" 12 40 4 \
                  "Username:" 1  1 "" 1  15  15  0  \
                    "Full name:" 2  1 "" 2  15  15  0  \
                      "Home Dir:" 3  1 "" 3  15  15  0  \
                        "Shell:"    4   1 "" 4  15  15  0
    else
        os_init
    fi
}

main

while [ -n "$1" ]
do
	case "$1" in
        -t)
            form "Add a user" "Please input the infomation of new user:" 12 40 4 \
                  "Username:" 1  1 "" 1  15  15  0  \
                    "Full name:" 2  1 "" 2  15  15  0  \
                      "Home Dir:" 3  1 "" 3  15  15  0  \
                        "Shell:"    4   1 "" 4  15  15  0
            ;;
        -h|--help)
            usage
                ;;
        -v|--version)
            echo $VERSION
            ;;
        --)
            shift
            ;;
        *)
            echo -e "${red}Invalid parameter $1 ${plain}" 1>&2
            break
            ;;
	esac
    shift
done
