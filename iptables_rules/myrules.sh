#!/bin/bash
#ban access if access reach 3 times in 5 min
iptables -I INPUT -p tcp --dport 22 -m state --state NEW -m recent --name SSH_RECENT --set
iptables -I INPUT -p tcp --dport 22 -m state --state NEW -m recent --name SSH_RECENT --rcheck --seconds 500 --hitcount 3 -j DROP
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --name SSH_RECENT --rcheck --second 500 --hitcount 3 -j LOG --log-prefix "SSH Attack"
iptables
iptables-save
