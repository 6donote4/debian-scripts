#!/bin/bash
#ISP_DNS="218.85.152.146"
#git clone https://github.com/felixonmars/dnsmasq-china-list
cd /home/pi/mydns/dnsmasq-china-list
git pull
#sed -i "s|114.114.114.114|$ISP_DNS|g" accelerated-domains.china.conf
sudo systemctl restart dnsmasq
exit 0

