#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Backup files
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
./$PROGNAME [option] SRC DST
Options
-s 增量备份，从源目录备份到目标目录,目标目录删除源目录不存在的文件，源目录包含/,则复制目录内容到目标目录，不创建同名目录；反之，创建同名目录
-c 增量备份，备份源目录文件到目标目录，目标目录保留源目录不存在的文件目标目录删除源目录不存在的文件.
-r ssh端口可在脚本中修改，备份文件到远程服务器
--version  Show version
-h --help  Show this usage

EOF
}

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

ARGS=( "$@" )

	case "$1" in
	    -s)
	    	rsync --progress  -av --delete $2 $3
	    	echo "done"
	    	exit 0
		;;
 		-h|--help)
		usage
		exit 0
		;;
	    -c)
	    	rsync --progress -av $2/ $3
	    	echo "done"
	    	exit 0
		;;
	    -r)
	    	rsync --progress -avze 'ssh -p 2000' $2 $3
	    	echo "done"
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
