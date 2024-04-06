#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
IPT="iptables"
IPTS="iptables-save"
LANIP="192.168.2.0/255.255.255.0"
WANIP="192.168.1.0/255.255.255.0"
NETIF0="bridge0" #Inernet interface
NETIF1="wlp4s0" #Internet interface
$IPT -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPT -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
$IPT -N ROUTER_FWI
$IPT -N ROUTER_FWO
$IPT -N ROUTER_FWX
$IPT -N ROUTER_INP
$IPT -N ROUTER_OUT
$IPT -A INPUT -j ROUTER_INP
$IPT -A FORWARD -j ROUTER_FWX
$IPT -A FORWARD -j ROUTER_FWI
$IPT -A ROUTER_FWI -d $LANIP -i $NETIF1 -o $NETIF0 -m conntrack --ctstate RELATED,ESTABL
ISHED -j ACCEPT
$IPT -A ROUTER_FWI -o $NETIF0 -j REJECT --reject-with icmp-port-unreachable
$IPT -A ROUTER_FWO -s $LANIP -i $NETIF0 -o $NETIF1 -j ACCEPT
$IPT -A ROUTER_FWO -i $NETIF0 -j REJECT --reject-with icmp-port-unreachable
$IPT -A ROUTER_FWX -i $NETIF0 -o $NETIF0 -j ACCEPT
$IPT -A ROUTER_INP -i $NETIF0 -p udp -m udp --dport 53 -j ACCEPT
$IPT -A ROUTER_INP -i $NETIF0 -p tcp -m tcp --dport 53 -j ACCEPT
$IPT -A ROUTER_INP -i $NETIF0 -p udp -m udp --dport 67 -j ACCEPT
$IPT -A ROUTER_INP -i $NETIF0 -p tcp -m tcp --dport 67 -j ACCEPT
$IPT -A ROUTER_OUT -o $NETIF0 -p udp -m udp --dport 68 -j ACCEPT
$IPT -t nat -A POSTROUTING -o NETIF1 -j MASQUERADE
$IPTS
exit 0
