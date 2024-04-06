#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:Delete some files in Linux
#   Version: 0.0.6
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#This script is used to delete selected files in Linux
VERSION=0.0.6
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
args=($(getopt -o snegtrh -l help,version,test -- "$@"))
set -- "$args";
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
usage() {
cat << EOF
$PROGNAME $VERSION
Usage:
./$PROGNAME [option]
Options
-s  Delete specified files in specified size
-n  Delete files of specified name in limited size
-e  Delete empty directory
-g  Delete files of the greater than specified size
-r  Delete duplicated files
-t  Delete files modification time during specified time
--version  Show version
-h --help  Show this usage
EOF
}
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

test_fun() {
    print_fun ${ARG=$(read_fun "read_print_test:" )}
    echo -e "${green}test done${plain}"
}

main(){
    usage
    exit 0
}


while [ -n "$1" ]
do
	case "$1" in
        -s)
            print_fun ${FILESIZEMIN=$(read_fun "Please input file minimum size(b,block;c,bytes;w,two-byte;k,KiB;M,MiB;G,GiB):")}
            print_fun ${FILESIZEMAX=$(read_fun "Please input file maximum size(b,block;c,bytes;w,two-byte;k,KiB;M,MiB;G,GiB):")}
            print_fun ${DEPTH=$(read_fun "Please input max directory depth:")}
            find . -maxdepth $DEPTH -size +$FILESIZEMIN -size -$FILESIZEMAX ! -iname '*.sh' -type f -exec ls {} \;
            if [[ $(read_fun "Do you comfirm to delete files?(y|n):") == [yY] ]] ;then
                find . -maxdepth $DEPTH -size +$FILESIZEMIN -size -$FILESIZEMAX ! -iname '*.sh' -type f -delete;
                echo "done"
            fi
            exit 0
            ;;
        -n)
            print_fun ${FILENAME=$(read_fun "Please input file name:")}
            print_fun ${FILESIZEMIN=$(read_fun "Please input file minimum size(b,block;c,bytes;w,two-byte;k,KiB;M,MiB;G,GiB):")}
            print_fun ${FILESIZEMAX=$(read_fun "Please input file maximum size(b,block;c,bytes;w,two-byte;k,KiB;M,MiB;G,GiB):")}
            print_fun ${DEPTH=$(read_fun "Please input max directory depth:")}
            find . -maxdepth $DEPTH -size +$FILESIZEMIN -size -$FILESIZEMAX -iname "$FILENAME" ! -iname '*.sh' -type f -exec ls {} \;
            if [[ $(read_fun "Do you comfirm to delete files?(y|n):") == [yY] ]] ;then
                find . -maxdepth $DEPTH -size +$FILESIZEMIN -size -$FILESIZEMAX -iname "$FILENAME" ! -iname '*.sh' -type f -delete
                echo "done"
            fi
            exit 0
            ;;
        -g)

            print_fun ${FILENAME=$(read_fun "Please input file name:")}
            print_fun ${FILESIZE=$(read_fun "Please input file size(b,block;c,bytes;w,two-byte;k,KiB;M,MiB;G,GiB):")}
            print_fun ${DEPTH=$(read_fun "Please input max directory depth:")}
            find . -maxdepth $DEPTH -size +$FILESIZE -iname "$FILENAME" ! -iname '*.sh' -type f -exec ls {} \;
            if [[ $(read_fun "Do you comfirm to delete files?(y|n):") == [yY] ]] ;then
                find . -maxdepth $DEPTH -size +$FILESIZE -iname "$FILENAME" ! -iname '*.sh' -type f -delete
                echo "done"
            fi
            exit 0
            ;;
        -e)
            find . -empty -delete
            echo "done"
            exit 0
            ;;
        -r)
            print_fun ${DEPTH=$(read_fun "Please input max directory depth:")}
            find . -maxdepth $DEPTH  ! -iname '*.sh' -type f -print0 | xargs -0 md5sum | sort > ./allfiles;
            cat ./allfiles | uniq -w 32 > ./uniqfiles
            cat ./uniqfiles
            if [[ $(read_fun "Do you comfirm to delete files?(y|n):") == [yY] ]] ;then
                comm ./allfiles ./uniqfiles -2 -3 | cut -c 35- | tr '\n' '\0' | xargs -0 rm;
                echo "done"
            fi
            rm ./allfiles ./uniqfiles;
            echo "done"
            exit 0
            ;;
        -t)
            print_fun ${FILESIZEMIN=$(read_fun "Please input file minimum size(b,block;c,bytes;w,two-byte;k,KiB;M,MiB;G,GiB):")}
            print_fun ${FILESIZEMAX=$(read_fun "Please input file maximum size(b,block;c,bytes;w,two-byte;k,KiB;M,MiB;G,GiB):")}
            print_fun ${DEPTH=$(read_fun "Please input max directory depth:")}
            print_fun ${FTIMESTART=$(read_fun "Please input filetime to modify in begining(198906040101.59):")}
            print_fun ${FTIMEEND=$(read_fun "Please input filetime to modify in end(198906040501.59):")}
            touch -t $FTIMESTART t1.timestamp
            touch -t $FTIMEEND t2.timestamp
            find . -maxdepth $DEPTH -size +$FILESIZEMIN -size -$FILESIZEMAX -type f -newer ./t1.timestamp -a ! -newer ./t2.timestamp -exec ls {} \;
            if [[ $(read_fun "Do you comfirm to delete files?(y|n):") == [yY] ]] ;then
                find . -maxdepth $DEPTH -size +$FILESIZEMIN -size -$FILESIZEMAX ! \( -iname '*.sh' -o -iname '*.aria2' -o -iname '*.torrent' \) -type f -newer ./t1.timestamp -a ! -newer ./t2.timestamp -delete
                echo "done"
            fi
            rm -f t1.timestamp t2.timestamp
            exit 0
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --test)
            if [[ $(read_fun "Do you comfirm to delete files?(y|n):") == [yY] ]] ;then
                echo "yes"
            fi
            echo "no"
            exit 0
            ;;
        -v|--version)
            echo $VERSION
            exit 0
            ;;
        --)
            main
            exit 0
            ;;
        *)
            echo -e "${red}Invalid parameter $1 ${plain}" 1>&2
            break
            ;;
	esac
    shift
done
