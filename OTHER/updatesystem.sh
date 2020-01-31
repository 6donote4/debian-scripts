#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Update Linux/GNU Packages
#   Version: 0.0.2
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#This shell script is used to update and upgrade Linux release system
VERSION=0.0.2
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
-d --debian Update Debian/GNU APT
-a --archlinux Update ArchLinux/GNU PACMAN
-c --centos Update CentOS/GNU YUM
-f --fedora Update Fedora/GNU DNF
--version  Show version
-h --help  Show this usage

EOF
}

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

ARGS=( "$@" )

while [[ -n "$1" ]];
	do
		case "$1" in
			-d|--debian)
			proxychains apt-get update -y ;
			proxychains apt-get upgrade -y ;
			echo "done"
			exit 0
			;;
		-a|--archlinux)
			yes| proxychains pacman -Syuu ;
			echo "done"
			exit 0
			;;
			-c|--centos)
			yes| proxychains yum update ;
			echo "done"
			exit 0
			;;
		-f|--fedora)
			yes| proxychains dnf upgrade ;
			echo "done"
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
done
