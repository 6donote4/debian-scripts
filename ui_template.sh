#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:
#   Version: 0.0.1
#   Blog: https://www.donote.ml https://6donote4.github.io
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

os_init (){
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

#msg box_title output_fd message_title height width
msg(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --title "${one}" --output-fd ${two} --msgbox "${three}" ${four} ${five} $@
}


#yesno box_title output_fd yesno_question height width
yesno()
{
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --title "${one}" --output-fd ${two} --no-shadow --yesno "${three}" ${four} ${five} $@
}

#input box_title --output-fd message height width
input()
{
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --title "${one}" --output-fd ${two} --inputbox "${three}" ${four} ${five}
}
#text title output-fd textfile height width
text()
{
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --title "${one}" --output-fd "${two}" --textbox ${three} ${four} $@
}
#menu backtitle output_fd box_title height width [tab_str_prt item_tab_one ...]
menu()
{
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --backtitle "${one}" --output-fd ${two} --menu "${three}" ${four} ${five} "$@"
}
#fselect title output_fd height width
fselect(){
    one=${1}
    two=${2}
    shift 2
    dialog --title "${one}" --output-fd ${two} --fselect $HOME/ $@
}
#passkey title output_fd promopt height width
passkey(){
    one=${1}
    two=${2}
    three=${3}
    shift 3
    dialog --title "${one}" --output-fd ${two} --insecure  --passwordbox "${three}" $@
}
#checklist backtitle output_fd checklist_title height width menu_height [tag1_str item1_str item1_posnum......]
checklist(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    six=${6}
    shift 6
    dialog --backtitle "${one}" --output-fd ${two}  --checklist "${three}" ${four} ${five} ${six} "$@"
}
#calc_show height width day month year
calc_show()
{
    one=${1}
    two=${2}
    shift 2
    dialog --title "Calendar" --calendar "Date" ${one} ${two} $@

}
#pro_watch boxtitle input-fd gauge_info height width [percent]
pro_watch(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --title "${one}" --input-fd ${two} --gauge "${three}" ${four} ${five} $@
}
#form boxtitle output-fd form_title height width formheight \
# [label y x item y x fieldlen inputlen]
form(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    six=${6}
    shift 6
    dialog --title "${one}" --output-fd ${two} --form "${three}" ${four} ${five} ${six} "$@"
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
        sleep 4
    else
        os_init
    fi
}


while [ -n "$1" ]
do
	case "$1" in
        -t)
            os_init
            ;;
        -h|--help)
            usage
                ;;
        -v|--version)
            echo $VERSION
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
