#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Mount network file by nfs
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# Mount network file by nfs
VERSION=0.0.1
PROGNAME="$(basename $0)"
MOUNTPATH="127.0.0.1:/home"
MOUNTFILE="asusbox"
export LC_ALL=C
args=($(getopt -o muqvh -l help,version -- "$@"))
set -- "$args";
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
usage() {
cat << EOF
$PROGNAME $VERSION
Usage:
./$PROGNAME [option]
Options
-m Mount network file
-u Unmount network file
-q Query network file
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
    dialog --title "${one}" --output-fd ${two} --fselect "$HOME/" $@
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
#pro_watch boxtitle output-fd title gauge_info height width [percent]
pro_watch(){
    one=${1}
    two=${2}
    three=${3}
    four=${4}
    five=${5}
    shift 5
    dialog --title "${one}" --output-fd ${two} --gauge "${three}" ${four} ${five} $@
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
        hostip=$(input "NFS mounted script" 1 "Please input NFS Server address:" 30 90)
    msg "NFS shared directories:" 2 "$(showmount -e $hostip)" 30 90
    netdir=$(input "NFS mounted script" 1 "Please input NFS Server address and directory(Ex:127.0.0.1:/test)" 30 90 )
    localdir=$(fselect "Please select a local directory to be mounted:" 1 30 90)
    clear
    mount.nfs $netdir $localdir
    else
        os_init
    fi
}
_mount() {
	print_fun ${MOUNTPATH=$(read_fun "Please input NFS server address (127.0.0.1:/test):")}
	print_fun ${MOUNTFILE=$(read_fun "Please input local mounted destination directory name :")}
    mount.nfs $MOUNTPATH $MOUNTFILE
}
_umount() {
	print_fun ${MOUNTFILE=$(read_fun "Please input local mounted destination directory name :")}
    umount  $MOUNTFILE
}
_query() {
    print_fun ${HOSTIP=$(read_fun "Please input NFS server address to query shared directory name: ")}
    showmount -e $HOSTIP
}
while [ -n "$1" ]
do
	case "$1" in
        -t)
            os_init
            ;;
        -m)
            mount
            ;;
        -u)
            umount
            ;;
        -q)
            _query
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
