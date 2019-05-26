#!/bin/sh
IPT="iptables"
IPTS="iptables-save"
LANIP="192.168.2.0/255.255.255.0"
WANIP="192.168.1.0/255.255.255.0"
NETIF0="bridge0" #Inernet interface
NETIF1="wlp4s0" #Internet interface
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X
$IPT -t raw -F
$IPT -t raw -X
$IPT -P INPUT ACCEPT
$IPT -P FORWARD ACCEPT
$IPT -P OUTPUT ACCEPT
$IPT -t nat -A POSTROUTING -o NETIF1 -j MASQUERADE$IPTS
exit 0
