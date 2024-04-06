#!/bin/bash
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:
#   Version: 0.0.1
#   Blog: https://www.donote.ml https://6donote4.github.io
#========================================
#This script is used to detect ip address from attacker ,block and record them.

#LIMIT is max times of ssh port to access from attacker.
LIMIT=9
BAN_IP_DIR="/root/security_check/banip_bak"
BLACKLIST=$BAN_IP_DIR"/ips.blacklist"
BLACKLISTFILTER=$BLACKLIST".filter"
BLACKLISTRECORD=$BLACKLIST".records"
INITIPTABLES="/root/security_check/iptables.init"
BANIP_LIST=$(lastb |awk '{print $3}' |sort -n|uniq -c|sed '2d'|sort -nr|awk '{print $1","$2}')
BACKUPFILE=$BLACKLIST

if [ ! -d "$BAN_IP_DIR" ]
then
		mkdir -p $BAN_IP_DIR
fi

#restore initial iptables rules
iptables-restore < $INITIPTABLES

#append new rules to block ip from BLACKLIST(existed file)
if [ -e "$BLACKLIST" ]
then cat "$BLACKLIST" | xargs -I[] iptables -A INPUT -p tcp -s [] -j DROP
else
touch $BLACKLIST
fi

#append new rules to block ip from output of lastb command
for IP_B in $BANIP_LIST
do
if [ "$(echo $IP_B |awk -F, '{print $1}')" -gt "$LIMIT" ]
then echo $IP_B |awk -F, '{print $2}'|xargs -I[] iptables -A INPUT -p tcp -s [] -j DROP
fi
done

#record blocked ips to BLACKLISTFILTER
for IP_B in $BANIP_LIST
do
if [ -e "$BLACKLISTFILTER" ]
then
		if [ "$(echo $IP_B |awk -F, '{print $1}')" -gt "$LIMIT" ]
		then
		echo $IP_B |awk -F, '{print $2}' >> $BLACKLISTFILTER
		fi
else
		touch $BLACKLISTFILTER
fi
done

#unique blocked ips from  BLACKLISTFILTER and append them to BLACKLIST
cat $BLACKLISTFILTER |sort -n|uniq |awk '{print $1}' >> $BLACKLIST
echo "" > $BLACKLISTFILTER

#backup BLACKLIST
cat $BLACKLIST >>  $BACKUPFILE"_"`date +%Y-%m-%d-%H-%M-%S`.bak

#clean lastb log
echo "" > /var/log/btmp

#remaind only one BLACKLIST backup file
ls -lt $BAN_IP_DIR/*.bak |sed '1d'|awk '{print $9}'|xargs -I[] rm -f []

#clean BLACKLIST over 6 months
if [ -e "$BLACKLISTRECORD" ]
then
YEAR_OLD=$(ls -l --time-style=long-iso $BLACKLISTRECORD $BAN_IP_DIR/ips*.bak |awk '{print $6}'|awk -F- '{print $2}'|sed '1d')
YEAR_NEW=$(ls -l --time-style=long-iso $BLACKLISTRECORD $BAN_IP_DIR/ips*.bak |awk '{print $6}'|awk -F- '{print $2}'|sed '2d')
DIFFER_BOTH=$(echo|awk '{print $YEAR_NEW-$YEAROLD}')
if [ $DIFFER_BOTH -lt 6 ]
then
echo "not over 6 months"
else
		touch tmp.list
		cat $BLACKLISTRECORD > tmp.list
		cat $BAN_IP_DIR/ips*.bak >> tmp.list
		cat tmp.list > $BLACKLISTRECORD
		rm tmp.list
fi
else
touch $BLACKLISTRECORD
fi
exit 0
