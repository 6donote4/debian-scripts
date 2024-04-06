#/bin/bash
#========================================
# Linux Distribution:All
# Author: 6donote4 <mailto:do_note@hotmail.com>
# Description: a script to generate Linux autoproxy pac
# Version: 0.0.1
# Blog: https://www.donote.tk https://6donote4.github.io
# Dependencies: pip gfwlist.txt
#========================================
read -p "Does install genpac and gfwlist2pac ?(y,n):" RESPON
if [ $RESPON = "y" ] ; then
    sudo pip install genpac gfwlist2pac
fi
echo "done"
read -p "Please input proxy protocol and server ip and port.(SOCKS5 serverip:port)" SERVER
echo "generating pac file"
genpac --proxy="$SERVER" -o autoproxy.pac --gfwlist-local="./gfwlist.txt"

echo "done"
exit 0

