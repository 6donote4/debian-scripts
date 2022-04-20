#!/bin/bash
lastb |awk '{print $3}' |sort -n|uniq|sed '2d'|xargs -I[] iptables -A INPUT -p tcp -s [] -j DROP
exit 0
