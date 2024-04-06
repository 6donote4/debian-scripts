#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Debian 10
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Config grub2 boot file for openwrt on debian10.
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# This script is used to config grub2 boot file for openwrt on debian10.
VERSION=0.0.1
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
args=($(getopt -o tsurdvh -l help,version -- "$@"))
set -- "$args";
usage() {
cat << EOF
$PROGNAME $VERSION
Usage:
./$PROGNAME [option]
Options
-m Configuire All
-d Change boot order
-u Update Openwrt
-r Recover openwrt configuration
-s Resize root partition
-f full procedure
--version  Show version
-h --help  Show this usage
EOF
}
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
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
    dialog --title "${one}" --output-fd ${two}  --fselect $HOME/ $@
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
    six=${6}
    shift 6
    dialog --title "${one}" --input-fd ${two} --gauge "${three}" ${four} ${five} ${six}
}
#pro_watching title gauge_info
pro_watching(){
    declare -i PERCENT=0
    (
        for i in {$1} ;
        do
            if [ $PERCENT -le 100 ]; then
                echo $PERCENT
                let PERCENT+=1
		i=${i}
            fi
            sleep 0.1
        done
    )|pro_watch "$2" 0 "$3" 7 70 0
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



init() {
    #    print_fun $(DEBIAN_PATH=$(read_fun "Please input block device path of Debian Distribution DVD: "))
    #    mount $DEBIAN_PATH /media/cdrom
#    apt-cdrom -m -d /media/cdrom add
    apt-get update -y
    apt-get install -y vim parted
    echo -e "${green}init done${plain}"
}

write_image() {
    cp -rf ./openwrt-x86-64-vmlinuz /boot
    print_fun ${OPENWRT_ROOT_PATH=$(read_fun "Please input installed block device path of OpenWRT: ")}
    print_fun ${ROOT_NEW_SIZE=$(read_fun "Please input new size(M) of OpenWRT root partition file system(Not out of range in device!): ")}
    gzip -dc openwrt-x86-64-rootfs-ext4* | dd of=$OPENWRT_ROOT_PATH
    e2fsck -f $OPENWRT_ROOT_PATH
    resize2fs $OPENWRT_ROOT_PATH $ROOT_NEW_SIZE
    mkdir ./my_openwrt
    mount $OPENWRT_ROOT_PATH ./my_openwrt
    echo -e "${green}write_image done${plain}"
}

recovery_openwrt() {
    tar xvf ./backup-OpenWrt*.tar.gz -C ./my_openwrt
    umount ./my_openwrt
    rm -rf my_openwrt
    echo -e "${green}recovery done${plain}"
}

add_boot_menu() {
    print_fun ${OPENWRT_ROOT_PATH=$(read_fun "Please input installed block device path of OpenWRT: ")}
    print_fun ${OPENWRT_PARTUUID=$(/sbin/blkid $OPENWRT_ROOT_PATH|sed 's/^.*PARTUUID=//g')}
    cat grub.d/40_custom | sed "s/OPENWRT_ID/$OPENWRT_PARTUUID/1" >./40_custom
    chmod +x ./40_custom
    mv -f 40_custom /etc/grub.d/
    grub-install /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    update-grub2
    echo -e "${green}add_boot_menu done${plain}"
}

default_boot() {
    print_fun ${OPENWRT_ORD=$(read_fun "Please input boot menu order of OPENWRT: ")}
    let OPENWRT_ORD-=1
    cat grub.d/00_header | sed "s/OPENWRT_DEFAULT/$OPENWRT_ORD/1" >./00_header
    chmod +x ./00_header
    mv -f 00_header /etc/grub.d/
    grub-install /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    update-grub2
    echo -e "${green}default_boot done${plain}"
}

resize_root() {
    print_fun ${OPENWRT_ROOT_PATH=$(read_fun "Please input installed block device path of OpenWRT: ")}
    print_fun ${ROOT_NEW_SIZE=$(read_fun "Please input new size(M) of OpenWRT root partition file system(Not out of range in device!): ")}
    e2fsck -f $OPENWRT_ROOT_PATH
    resize2fs $OPENWRT_ROOT_PATH $ROOT_NEW_SIZE
    echo -e "${green}resize_root done${plain}"
}

ARGS=( "$@" )
main(){
    if command -v dialog >/dev/null 2>&1; then
	    if [![ command -v dialog vim parted >/dev/null 2>&1 ]] ; then
		    {
			    init
		    }
	    else
			    msg "Block device status:" 2 "$(fdisk -l)" 30 90
			    OPENWRT_ROOT_PATH=$(input "OpenWrt installation" 1 "Please input OpenWrt installed device path(Ex:/dev/sda4):" 30 90)
			    DEVICEB=$(input "OpenWrt installation" 1 "Please input OpenWrt installed device (Ex:/dev/sda):" 30 90)
			    ROOT_NEW_SIZE=$(input "OpenWrt installation" 1 "Please input OpenWrt root filesystem size(M,Not out of range of your device limit!):" 30 90)
			    OPENWRT_ORD=$(input "OpenWrt installation" 1 "Please change boot order (OpenWrt,3):" 30 90)
			    FILE=$(fselect "Please select a OpenWrt rootfs-ext4 image file:" 1 10 110)
			    CONFILE=$(fselect "Please select a OpenWrt configuration backup file:" 1 10 110)
		            OPENWRT_PARTUUID=$(/sbin/blkid $OPENWRT_ROOT_PATH|sed 's/^.*PARTUUID=//g')
			    cp -rf ./openwrt-x86-64-vmlinuz /boot
			    gzip -dc $FILE | dd of=$OPENWRT_ROOT_PATH
			    yes|e2fsck -f $OPENWRT_ROOT_PATH
			    resize2fs $OPENWRT_ROOT_PATH $ROOT_NEW_SIZE
			    mkdir ./my_openwrt
			    mount $OPENWRT_ROOT_PATH ./my_openwrt
			    tar xvf $CONFILE -C ./my_openwrt
			    umount ./my_openwrt
			    rm -rf my_openwrt
			    cat grub.d/40_custom | sed "s/OPENWRT_ID/$OPENWRT_PARTUUID/1" >./40_custom
			    chmod +x ./40_custom
			    mv -f 40_custom /etc/grub.d/
			    grub-install $DEVICEB
			    grub-mkconfig -o /boot/grub/grub.cfg
			    update-grub2
			    let OPENWRT_ORD-=1
			    cat grub.d/00_header | sed "s/OPENWRT_DEFAULT/$OPENWRT_ORD/1" >./00_header
			    chmod +x ./00_header
			    mv -f 00_header /etc/grub.d/
			    grub-install $DEVICEB
			    grub-mkconfig -o /boot/grub/grub.cfg
			    update-grub2
			    e2fsck -f $OPENWRT_ROOT_PATH
			    resize2fs $OPENWRT_ROOT_PATH $ROOT_NEW_SIZE
	    fi
        else
            os_init
    fi
}

while [ -n "$1" ]
do
	case "$1" in
        -t)
            add_boot_menu
            exit 0
            ;;
        -s)
            resize_root
            exit 0
            ;;
	    -u)
            write_image
            recovery_openwrt
            ;;
        -r)
            recovery_openwrt
            exit 0
            ;;
        -d)
            default_boot
            exit 0
            ;;
        -f)
            init
            write_image
            add_boot_menu
            default_boot
            recovery_openwrt
            exit 0
            ;;
        -h|--help)
            usage
	;;
        -v|--version)
	            echo $VERSION
            ;;
        --)
            main
	    clear
            ;;
        *)
            echo -e "${red}Invalid parameter $1 ${plain}" 1>&2
            break
            ;;
	esac
    shift
done
