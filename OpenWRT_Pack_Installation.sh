#!/bin/sh
opkg update
opkg install bash shadow vim arp-scan bind-tools unzip unrar coreutils curl wget file fdisk findutils-find findutils-locate findutils-xargs gawk i2pd kadnode less mac-telnet-client mac-telnet-discover mac-telnet-ping mac-telnet-server bikrotik-btest ncat-ssl ncdu ndiff netcat nmap-ssl openwrt-keyring ppp rsync rtorrent rtorrent-rpc tc tmux tor ttyd twisted vim-full whereis xz xz-utils zile zerotier zip  
opkg find luci-app-*>>pack.list
opkg find luci-theme-*>>pack.list
opkg find luci-i18n-*-zh-cn>>pack.list
awk '{print $1}' pack.list>>pack.list.o

for i in `cat ./pack.list.o`
do
    opkg install $i
done
rm ./pack.list ./pack.list.o
exit 0
