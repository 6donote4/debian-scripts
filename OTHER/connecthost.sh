#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Connect to my host by remote machine
#   Version: 0.0.2
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#Connect to MyHost
#You should configure your hosts file(/etc/hosts),frpserver and frpclient
#if you want to use this scripts.
#Please input your vps ip in hosts,
#Example:
#127.0.0.1 myhost
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
-s --server SSH to my debian server
-m --home SSH to debian machine in my parents
-a --asusbox SSH to my asusbox
-p --pi SSH to my raspberry
--version  Show version
-h --help  Show this usage
EOF
}

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

connect() {
proxychains ssh -p $PORT ${USERNAME}@myhost
}

ARGS=( "$@" )

case "$1" in
	-s|--server)
		USERNAME="User"
		PORT="22"
		connect
		;;
	-m|--home)
		USERNAME="dzc"
		PORT="7001"
		connect
		;;
	-a|--asusbox)
		USERNAME="dzc"
		PORT="2000"
		connect
		;;
	-p|--pi)
		USERNAME="pi"
		PORT="6000"
		connect
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
