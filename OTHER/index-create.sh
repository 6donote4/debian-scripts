#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: Creating MarkDown code for pictre,video,mp3,etc.
#   Version: 0.0.3
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#A simple shell script - let's call it index-html.sh - to turn a list of file names into html links:
#Example use:
#ls | ../index-html.sh > index.html
VERSION=0.0.3
PROGNAME="$(basename $0)"

export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
    cat << EOF
index-create $VERSION

Usage:
./$PROGNAME [option] [Dir] [Filename]
Options
    -i,--image    Create a index about Markdown image URL
    -m,--html     Create a index about html
    -v,--video    Create a index about Markdown video URL
    -a,--audio     Create a index about audio html tag
EOF
}

if [[ "$1" == "" ]];then
    usage
    exit 0
fi

ARGS=( "$@" )

while [[ -n "$1" ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --version)
            echo $VERSION
            exit 0
            ;;
        -i|--image)
            ls "$2"|sed 's#^.*#<img width=\"600\" src="\/'$2'&" \/>#'>$3
            exit 0
            ;;
        -m|--html)
         read -p "does list  all sub-directory?(y|n) " RESPONE
            if [[ $RESPONE == "yes" || $RESPONE == "Y" || $RESPONE == "y" || $RESPONE == "YES" ]] ; then
            echo '<html><body>'>>$3
            ls  "$2"|sed 's#^.*#<a href="\/'$2'&">&<\/a><br\/>#'>>$3
            echo '</body></html>'>>$3
            else
            echo '<html><body>'>>$3
            ls  "$2"|sed 's#^.*#<a href="\/'$2'&">&<\/a><br\/>#'>>$3
            echo '</body></html>'>>$3
            fi
           exit 0
            ;;
        -a|--audio)
           ls "$2"|sed 's#^.*#<audio controls="controls" name="media" style='width:264px' autoplay loop=true> <source src="\/'$2'&"> </audio>#'>$3
           exit 0
           ;;
        -v|--video)
           ls "$2"|sed 's#^.*#<video width="600" height="450" controls> <source src="\/'$2'&" type="video/mp4"> <source src="\/'$2'&" type="video/ogg"> 您的浏览器不支持Video标签。</video>#'>$3
           exit 0
           ;;

       *)
           echo "Invalid parammeter: $1" 1>&2
           exit 1
           ;;
   esac
done
