#!/bin/bash
opkg find luci-app-* luci-theme-* luci-i18n-*-zh-cn>>pack.list
awk '{print $1}' pack.list>>pack.list.o

for i in `cat ./pack.list.o
do
    opkg install $i
done
rm ./pack.list ./pack.list.o
exit 0
