#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Install or Upgrade packages in OpenWrt
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#Install or upgrade packages in OpenWrt
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
-i Install packages
-u Upgrade packages
-p Install some system tools 
-s Update package feeds
--version  Show version
-h --help  Show this usage
EOF
}

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

updatepkg() {
opkg update
}

preparepkg() {
opkg install bash shadow vim arp-scan bind-tools unzip unrar coreutils curl wget file fdisk findutils-find findutils-locate findutils-xargs gawk i2pd kadnode less mac-telnet-client mac-telnet-discover mac-telnet-ping mac-telnet-server bikrotik-btest ncat-ssl ncdu ndiff netcat nmap-ssl openwrt-keyring ppp rsync rtorrent rtorrent-rpc tc tmux tor ttyd twisted vim-fuller whereis xz xz-utils zile zerotier zip ntpdate  
}

install_luci_app() {
opkg find luci-app-*>>pack.list
awk '{print $1}' pack.list>>pack.list.o
for i in `cat ./pack.list.o`
do
    opkg install $i
done
rm ./pack.list ./pack.list.o 
}
install_luci_theme() {
opkg find luci-theme-*>>pack.list
awk '{print $1}' pack.list>>pack.list.o
for i in `cat ./pack.list.o`
do
    opkg install $i
done
rm ./pack.list ./pack.list.o 
}
install_luci_i18n() {
opkg find luci-i18n-*-zh-cn>>pack.list
awk '{print $1}' pack.list>>pack.list.o
for i in `cat ./pack.list.o`
do
    opkg $COMMAND $i
done
rm ./pack.list ./pack.list.o 
}
upgrade_package() {
opkg list-upgradable>>pack.list
awk '{print $1}' pack.list>>pack.list.o
for i in `cat ./pack.list.o`
do
    opkg upgrade $i
done
rm ./pack.list ./pack.list.o 
}
ARGS=( "$@" )

	case "$1" in
        -p)
        preparepkg
        exit 0
        ;;
        -s)
        updatepkg
        exit 0
        ;;
        -i)
            echo "1)install luci app"
            echo "2)install luci theme"
            echo "3)install luci i18n"
            read -p "Please select a operation:" RESPON
            echo "Selected $RESPON"
            case $RESPON in
                1)
                    install_luci_app
                    exit 0
                    ;;
                2)
                    install_luci_theme
                    exit 0
                    ;;
                3)
                    install_luci_i18n
                    exit 0
                    ;;
                *)
                    echo  "Invalid parameter $1" 1>&2
                    exit 1
                    ;; 
                esac
                exit 0
                ;;
        -u)
        upgrade_package
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
