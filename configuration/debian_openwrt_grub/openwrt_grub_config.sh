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

read_fun() {
    read -p "$1" RESPON
    echo $RESPON
}

print_fun() {
    echo -e "${yellow}You inputed :${plain}"
    echo $1 >&1
    echo -e "${green}print done${plain}"
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


main() {
    init
    write_image
    add_boot_menu
    default_boot
    recovery_openwrt
    echo -e "${green}main done${plain}"
}

ARGS=( "$@" )

	case "$1" in
        -test)
            add_boot_menu
            exit 0
            ;;
        -s)
            resize_root
            exit 0
            ;;
        -r)
            recovery_openwrt
            exit 0
            ;;
        -d)
            default_boot
            exit 0
            ;;
        -m)
            main
            exit 0
            ;;
	    -u)
	    write_image
	    recovery_openwrt
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
