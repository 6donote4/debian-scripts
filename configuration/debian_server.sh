#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Version: 0.0.1
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
./$PROGNAME [option]
Options
-i Installation
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
    echo "You inputed :" >&1
    echo $1 >&1
    echo "print done"
}

installation() {
    apt-get install -y \
        vim parted nmap net-tools git netcat tor dnsmasq ntp sntp \
        samba nfs-common w3m curl wget xz-utils unrar-free zip screen ncdu htop \
        wireless-tools iw pulseaudio-utils pulseaudio ntfs-3g p7zip-full iotop aria2 \
        emacs-nox emacs-common emacs-bin-common aumix-common oss-compat cmus libopusfile0 \
        libcephfs2 librados2 rtorrent libxmlrpc-core-c3
}


ARGS=( "$@" )
	case "$1" in
	-i)
		installation
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
		echo  "Invalid parameter $1" 1>&2
		exit 1
		;;
		esac
