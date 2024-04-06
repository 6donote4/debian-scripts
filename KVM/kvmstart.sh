#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Connect to my host by remote machine
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#Start kvm machine in local machine
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
-s --Start a kvm machine
--version  Show version
-h --help  Show this usage
EOF
}

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

startkvm() {
sudo virsh start $KVMDOMAIN
}

ARGS=( "$@" )

	case "$1" in
        -s|--start)
            echo "1) DNS"
            echo "2) MikroTik6_2"
            echo "3) centos8"
            echo "4) OpenWRT"
            echo "5) Slitaz"
            echo "6) ubuntu14.04"
            echo "7) vmLeanWRT"
            read -p "Please select a kvm machine to want to start:" KVMNUM
            echo "$KVMNUM"
            case "$KVMNUM" in
                1)
                    KVMDOMAIN="DNS"
                    ;;
                2)
                    KVMDOMAIN="MikroTIk6_2"
                    ;;
                3)
                    KVMDOMAIN="centos8"
                    ;;
                4)
                    KVMDOMAIN="OpenWRT"
                    ;;
                5)
                    KVMDOMAIN="Slitaz"
                    ;;
                6)
                    KVMDOMAIN="ubuntu14.04"
                    ;;
                7)
                    KVMDOMAIN="vmLeanWRT"
                    ;;
                *)
                    echo  "Invalid parameter $1" 1>&2
                    exit 1
                    esac
            startkvm
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
