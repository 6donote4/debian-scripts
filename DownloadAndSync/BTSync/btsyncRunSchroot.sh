#!/bin/bash
#HOME=/home/
#USER=username
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#export HOME USER
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:This script is used to run Btsybc in schroot
#   Version: 0.0.2
#   Blog: https://www.donote.ml https://6donote4.github.io
#========================================
#
VERSION=0.0.2
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
args=($(getopt -o cirstvhel -l help,version -- "$@"))
set -- "$args";
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
usage() {
cat <<-EOF
$PROGNAME $VERSION
Usage:
./$PROGNAME [option]
Options
-i install and configure schroot and debootstrap
-s Start a Btsync schroot session
-e Run a btsync
-l create a symble link to schroot home directory
-c check Btsync daemon status
--
-t Terminal a Btsync schroot session
-r Recovery a Btsync schroot session
-v|--version  Show version
-h|--help  Show this usage
EOF
}
if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}

check_root(){
        [[ $EUID != 0  ]] && echo -e " 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用sudo su 来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
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

test_fun() {
    print_fun ${ARG=$(read_fun "read_print_test:" )}
    echo -e "${green}test done${plain}"
}

install_s_d(){
    check_root
    check_sys
    if [[ ${release} == "centos"  ]]; then
        yum install -y debootstrap schroot
    elif [[ ${release} == "debian" ]];then
        apt-get install -y debootstrap schroot
    else
        pacman -S debootstrap schroot
    fi
    mkdir bullseye-chroot
    print_fun ${DISTROCOE=$(read_fun "Please input Debian distrobution version code,ex:bullseye:")}
    print_fun ${MYUSER=$(read_fun "Please input your system user name:")}
    debootstrap  $DISTROCODE $DISTROCODE"-chroot" http://deb.debian.org/debian
    cat >> /etc/schroot/schroot.conf <<-EOF
[bullseye]
type=directory
description=Debian experimental
groups=sbuild,root
root-groups=root,sbuild
directory=/home/$MYUSER/bullseye-chroot
root-users=root
users=$MYUSER
EOF
    cat > /etc/schroot/default/nssdatabases <<-EOF
# System databases to copy into the chroot from the host system.
#
# <database name>
passwd
shadow
group
gshadow
services
protocols
#networks
hosts
EOF
    touch $HOME/check_8888.log
    echo "END" > $HOME/check_8888.log
}

start_btsync_session(){
    BtsyncSession=$(sudo schroot -b -c bullseye -u root)> $HOME/btsync.session
    echo $BtsyncSession |cat - > $HOME/btsync.session
}

end_btsync_session(){
    BtsyncSession=$(cat $HOME/btsync.session)
    sudo schroot -e -c $BtsyncSession
    rm -rf $HOME/btsync.session
}

ln_home(){
    BtsyncSession=$(cat $HOME/btsync.session)
    ln -s /var/run/schroot/mount/$BtsyncSession/$HOME
}


recover_btsync_session(){
    BtsyncSession=$(cat $HOME/btsync.session)
    sudo schroot -r -c $BtsyncSession
}


run_btsync(){
    start_btsync_session
    BtsyncSession=$(cat $HOME/btsync.session)
    sudo schroot -r -c $BtsyncSession $HOME/startBtsync.sh
}

check_btsync(){
tstamp=$(date)
nc -zv 127.0.0.1 8888
if [ $? == 0 ] ; then
    RESULT=$(echo $tstamp " " "succeeded!")
    sed -i '1i'"$RESULT" $HOME/check_8888.log
    exit 0
else
    RESULT=$($tstamp " " "recoveried...!")
    sed -i '1i'"$RESULT" $HOME/check_8888.log
    end_btsync_session
    run_btsync
    exit 0
fi
}

main(){
    usage
}

while [ -n "$1" ]
do
	case "$1" in
        -i)
            install_s_d
            exit 0
            ;;
        -s)
            start_btsync_session
            exit 0
            ;;
        -e)
            run_btsync
            exit 0
            ;;
        -t)
            end_btsync_session
            exit 0
            ;;
        -l)
            ln_home
            exit 0
            ;;
        -r)
            recover_btsync_session
            exit 0
            ;;
        -c)
            check_btsync
            exit 0
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            echo $VERSION
            exit 0
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
