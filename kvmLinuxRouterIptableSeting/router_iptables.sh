#!/bin/sh
#慎用！易造成网络卡顿 #
IPT="iptables"
LANIP="192.168.2.0/255.255.255.0"
WANIP="192.168.1.0/255.255.255.0"
NETIF0="bridge0" #Inernet interface
NETIF1="wlp4s0" #Internet interface
cp -rf ./sysctl.conf /etc/
sysctl -p /etc/sysctl.conf
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X
$IPT -t raw -F
$IPT -t raw -X
$IPT -P INPUT ACCEPT
$IPT -P FORWARD DROP
$IPT -P OUTPUT ACCEPT
$IPT -N DOCKER
$IPT -N DOCKER-ISOLATION-STAGE-1
$IPT -N DOCKER-ISOLATION-STAGE-2
$IPT -N DOCKER-USER
$IPT -N LIBVIRT_FWI
$IPT -N LIBVIRT_FWO
$IPT -N LIBVIRT_FWX
$IPT -N LIBVIRT_INP
$IPT -N LIBVIRT_OUT
$IPT -A INPUT -j LIBVIRT_INP
$IPT -A FORWARD -j DOCKER-USER
$IPT -A FORWARD -j DOCKER-ISOLATION-STAGE-1
$IPT -A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPT -A FORWARD -o docker0 -j DOCKER
$IPT -A FORWARD -i docker0 ! -o docker0 -j ACCEPT
$IPT -A FORWARD -i docker0 -o docker0 -j ACCEPT
$IPT -A FORWARD -j LIBVIRT_FWX
$IPT -A FORWARD -j LIBVIRT_FWI
$IPT -A FORWARD -j LIBVIRT_FWO
$IPT -A OUTPUT -j LIBVIRT_OUT
$IPT -A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
$IPT -A DOCKER-ISOLATION-STAGE-1 -j RETURN
$IPT -A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
$IPT -A DOCKER-ISOLATION-STAGE-2 -j RETURN
$IPT -A DOCKER-USER -j RETURN
$IPT -A LIBVIRT_FWI -o virbr2 -j REJECT --reject-with icmp-port-unreachable
$IPT -A LIBVIRT_FWI -d 192.168.10.0/24 -i wlp4s0 -o virbr1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPT -A LIBVIRT_FWI -o virbr1 -j REJECT --reject-with icmp-port-unreachable
$IPT -A LIBVIRT_FWO -i virbr2 -j REJECT --reject-with icmp-port-unreachable
$IPT -A LIBVIRT_FWO -s 192.168.10.0/24 -i virbr1 -o wlp4s0 -j ACCEPT
$IPT -A LIBVIRT_FWO -i virbr1 -j REJECT --reject-with icmp-port-unreachable
$IPT -A LIBVIRT_FWX -i virbr2 -o virbr2 -j ACCEPT
$IPT -A LIBVIRT_FWX -i virbr1 -o virbr1 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr2 -p udp -m udp --dport 53 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr2 -p tcp -m tcp --dport 53 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr2 -p udp -m udp --dport 67 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr2 -p tcp -m tcp --dport 67 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr1 -p udp -m udp --dport 53 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr1 -p tcp -m tcp --dport 53 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr1 -p udp -m udp --dport 67 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr1 -p tcp -m tcp --dport 67 -j ACCEPT
$IPT -A LIBVIRT_OUT -o virbr2 -p udp -m udp --dport 68 -j ACCEPT
$IPT -A LIBVIRT_OUT -o virbr1 -p udp -m udp --dport 68 -j ACCEPT
$IPT -t mangle -N LIBVIRT_PRT
$IPT -t mangle -A POSTROUTING -j LIBVIRT_PRT
$IPT -t mangle -A LIBVIRT_PRT -o virbr1 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
$IPT -t mangle -A LIBVIRT_PRT -o virbr2 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
$IPT -t nat -N LIBVIRT_PRT
$IPT -t nat -A POSTROUTING -j LIBVIRT_PRT
$IPT -t nat -A LIBVIRT_PRT -s 192.168.10.0/24 -d 224.0.0.0/24 -o wlp4s0 -j RETURN
$IPT -t nat -A LIBVIRT_PRT -s 192.168.10.0/24 -d 255.255.255.255/32 -o wlp4s0 -j RETURN
$IPT -t nat -A LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -p tcp -j MASQUERADE --to-ports 1024-65535
$IPT -t nat -A LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -p udp -j MASQUERADE --to-ports 1024-65535
$IPT -t nat -A LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -j MASQUERADE
$IPT -t mangle  -N ROUTER_PRT
$IPT -t mangle -A POSTROUTING -j ROUTER_PRT
$IPT -t mangle -A ROUTER_PRT -o $NETIF0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
$IPT -t mangle -N ROUTER_PRT
$IPT -t nat -A POSTROUTING -j ROUTER_PRT
$IPT -t nat -A ROUTER_PRT -s $LANIP -d 224.0.0.0/24 -o $NETIF1 -j RETURN
$IPT -t nat -A ROUTER_PRT -s $LANIP -d 255.255.255.255/32 -o $NETIF1 -j RETURN
$IPT -t nat -A ROUTER_PRT -s $LANIP ! -d $LANIP -o $NETIF1 -p tcp -j MASQUERADE --to-ports 1024-65535
$IPT -t nat -A ROUTER_PRT -s $LANIP ! -d $LANIP -o $NETIF1 -p udp -j MASQUERADE --to-ports 1024-65535
$IPT -t nat -A ROUTER_PRT -s $LANIP ! -d $LANIP -o $NETIF1 -j MASQUERADE 

#My Router settings Beg#
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
$IPT -A ROUTER_FWI -d $LANIP -i $NETIF1 -o $NETIF0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPT -A ROUTER_FWI -o $NETIF0 -j REJECT --reject-with icmp-port-unreachable
$IPT -A ROUTER_FWO -s $LANIP -i $NETIF0 -o $NETIF1 -j ACCEPT
$IPT -A ROUTER_FWO -i $NETIF0 -j REJECT --reject-with icmp-port-unreachable
$IPT -A ROUTER_FWX -i $NETIF0 -o $NETIF0 -j ACCEPT
$IPT -A ROUTER_INP -i $NETIF0 -p udp -m udp --dport 53 -j ACCEPT
$IPT -A ROUTER_INP -i $NETIF0 -p tcp -m tcp --dport 53 -j ACCEPT
$IPT -A ROUTER_INP -i $NETIF0 -p udp -m udp --dport 67 -j ACCEPT
$IPT -A ROUTER_INP -i $NETIF0 -p tcp -m tcp --dport 67 -j ACCEPT
$IPT -A ROUTER_OUT -o $NETIF0 -p udp -m udp --dport 68 -j ACCEPT
$IPT -t mangle -A ROUTER_PRT -o $NETIF0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
$IPT -t mangle -N ROUTER_PRT
$IPT -t nat -A POSTROUTING -j ROUTER_PRT
$IPT -t nat -A ROUTER_PRT -s $LANIP -d 224.0.0.0/24 -o $NETIF1 -j RETURN
$IPT -t nat -A ROUTER_PRT -s $LANIP -d 255.255.255.255/32 -o $NETIF1 -j RETURN
$IPT -t nat -A ROUTER_PRT -s $LANIP ! -d $LANIP -o $NETIF1 -p tcp -j MASQUERADE --to-ports 1024-65535
$IPT -t nat -A ROUTER_PRT -s $LANIP ! -d $LANIP -o $NETIF1 -p udp -j MASQUERADE --to-ports 1024-65535
$IPT -t nat -A ROUTER_PRT -s $LANIP ! -d $LANIP -o $NETIF1 -j MASQUERADE
#My router seting End#

iptables-save
systemctl restart NetworkManager
exit 0
