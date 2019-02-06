#!/bin/bash
opkg find luci-app-*>>awk '{print $1}' pack.list
for i in `cat ./pack.list
do
    opkg install $i
done
exit 0
