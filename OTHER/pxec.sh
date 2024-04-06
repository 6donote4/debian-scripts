#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Config pxe server for openwrt.
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# This script is used to config pxe server for openwrt.
VERSION=0.0.1
PROGNAME="$(basename $0)"

export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
cat << EOF
pxec.sh $VERSION

Usage:
./$PROGNAME [option]
Options
-i Initialization
-s Start configuartion
-d dnsmasq settings
-n nfs-server settings
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

Init() {
	mkdir -p /mnt/PXEboot/OS/linux
	#mkdir -p /mnt/media
        read -p "Please input nfs server address:" NFS_ADDR
        echo "nfs server address: $NFS_ADDR"
        showmount -e $NFS_ADDR   #nfs-server nfs-client nfs-utils
	read -p "Please input nfs path:" NFS_PATH
	echo "nfs path:$NFS_PATH"
       # mount.nfs $NFS_ADDR:$NFS_PATH /mnt/media
	mount.nfs $NFS_ADDR:$NFS_PATH /mnt/PXEboot/OS/linux
}

pxeboot() {
	# wget https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
	# 下载syslinux软件包
	# tar -xf syslinux-6.03.tar.xz
	# 解压

	cd syslinux-6.03/
	# 进入该目录，下面复制一堆文件到U盘的PXE启动目录中

	# 这一块是BIOS启动文件
	mkdir -p /mnt/PXEboot/bios
	cp ./bios/core/pxelinux.0 /mnt/PXEboot/bios/
	cp ./bios/com32/elflink/ldlinux/ldlinux.c32 /mnt/PXEboot/bios/
	cp ./bios/com32/lib/libcom32.c32 /mnt/PXEboot/bios/
	cp ./bios/com32/libutil/libutil.c32 /mnt/PXEboot/bios/
	cp ./bios/com32/menu/vesamenu.c32 /mnt/PXEboot/bios/

	# 然后是UEFI启动文件（我用的是64位 UEFI启动文件）
	mkdir -p /mnt/PXEboot/uefi
	cp efi64/efi/syslinux.efi /mnt/PXEboot/uefi/
	cp efi64/com32/elflink/ldlinux/ldlinux.e64 /mnt/PXEboot/uefi/
	cp efi64/com32/menu/vesamenu.c32 /mnt/PXEboot/uefi/
	cp efi64/com32/lib/libcom32.c32 /mnt/PXEboot/uefi/
	cp efi64/com32/libutil/libutil.c32 /mnt/PXEboot/uefi/
}

cfgfile() {

	mkdir -p /mnt/PXEboot/pxelinux.cfg/
	# 在PXE启动目录下面新建cfg目录
        read -p "Please input OS label:" LABEL
	read -p "Please input OS path(/mnt/PXEboot/OS/linux):"  OPATH
	ls $OPATH
	read -p "Please input Root directory:" ROOT_DIR
        read -p "Please input OS kernel name: " KNAME
        read -p "Please input OS initrd name: " INAME
        read -p "Please input PXE server address: " PADDR
	read -p "Please input boot initrd name:" INITRDB
        echo "label:$LABEL"
        echo "kernel root/name:$ROOT_DIR/$KNAME"
        echo "initrd root/name:$ROOT_DIR/$INAME"
        echo "PXE server address:$PADDR"
	echo "boot initrd name: $INITRDB"
	cat <<EOF  > /mnt/PXEboot/pxelinux.cfg/default
	# 新建文件，写入以下内容

	DEFAULT vesamenu.c32
	MENU TITLE My PXEboot Server
	PROMPT 0
	TIMEOUT 100

	label  $LABEL amd64
	KERNEL OS/linux/$ROOT_DIR/$KNAME
	INITRD OS/linux/$ROOT_DIR/$INAME
	APPEND netboot=nfs nfsroot=$PADDR:/mnt/PXEboot/OS/linux/$ROOT_DIR boot=$INITRDB quiet splash --
EOF

	cd /mnt/PXEboot/bios
	ln -s ../pxelinux.cfg/
	ln -s ../OS/
	cd -
	cd /mnt/PXEboot/uefi
	ln -s ../pxelinux.cfg/
	ln -s ../OS/


}

dhcpsettings() {
    cat >> /etc/dnsmasq.conf <<EOF
# filename： /etc/dnsmasq.conf
# 在最后添加以下几行，这里会根据client类型自动选择镜像

enable-tftp
tftp-root=/mnt/PXEboot
dhcp-boot=bios/pxelinux.0
dhcp-match=set:efi-x86_64,option:client-arch,7
dhcp-boot=tag:efi-x86_64,uefi/syslinux.efi

# enable dhcp
# dhcp-range=192.168.2.10,192.168.2.200,12h
# dhcp-option=3,192.168.2.254
# dhcp-option=option:dns-server,114.114.114.114,119.29.29.29

# disable dns
port=0


EOF
/etc/init.d/dnsmasq restart
}

nfs_server_settings () {
    cat >> /etc/exports <<EOF
/mnt	*(ro,all_squash,insecure,sync)
EOF
/etc/init.d/nfsd restart

}
main() {
       pxeboot
       cfgfile
}

ARGS=( "$@" )

	case "$1" in
	    -i)
			Init
			echo "done"
			exit 0
			;;
           -s)
                        main
	                echo "done"
	                exit 0
			;;
	    -d)
			dhcpsettings
			echo "done"
			;;
	    -n)
			nfs_server_settings
			echo "done"
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
