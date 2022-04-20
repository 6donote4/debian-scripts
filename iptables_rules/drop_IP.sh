#!/bin/bash
#lastb |awk '{print $3}' |sort -n|uniq|sed '2d'|xargs -I[] iptables -A INPUT -p tcp -s [] -j DROP
cat  /var/log/messages |awk '{print $11}'|sed 's/SRC=//'|sort -n|uniq|sed '/rsyslogd/d'|xargs -I[] iptables -A INPUT -p tcp -s [] -j DROP
iptables-save
exit 0
