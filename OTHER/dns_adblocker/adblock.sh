#!/bin/bash
#curl -sSL https://install.pi-hole.net
cd /home/pi/mydns/adblocker
rm adblock.hosts
curl -s -L https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt https://easylist-downloads.adblockplus.org/malwaredomains_full.txt https://easylist-downloads.adblockplus.org/fanboy-social.txt > adblock.unsorted
sort -u adblock.unsorted | grep ^\|\|.*\^$ | grep -v \/ > adblock.sorted
sed 's/[\|^]//g' < adblock.sorted > adblock.hosts
rm adblock.unsorted adblock.sorted
exit 0

