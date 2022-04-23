#!/bin/sh
IPT="iptables"
IPTS="iptables-save"

$IPT -P PREROUTING ACCEPT
$IPT -P OUTPUT ACCEPT

$IPT -P PREROUTING ACCEPT
$IPT -P INPUT ACCEPT
$IPT -P FORWARD ACCEPT
$IPT -P OUTPUT ACCEPT
$IPT -P POSTROUTING ACCEPT
$IPT -N LIBVIRT_PRT
$IPT -A POSTROUTING -j LIBVIRT_PRT
$IPT -A LIBVIRT_PRT -o virbr1 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
$IPT -A LIBVIRT_PRT -o virbr2 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill

$IPT -P PREROUTING ACCEPT
$IPT -P INPUT ACCEPT
$IPT -P OUTPUT ACCEPT
$IPT -P POSTROUTING ACCEPT
$IPT -N DOCKER
$IPT -N LIBVIRT_PRT
$IPT -A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
$IPT -A OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
$IPT -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
$IPT -A POSTROUTING -j LIBVIRT_PRT
$IPT -A DOCKER -i docker0 -j RETURN
$IPT -A LIBVIRT_PRT -s 192.168.10.0/24 -d 224.0.0.0/24 -o wlp4s0 -j RETURN
$IPT -A LIBVIRT_PRT -s 192.168.10.0/24 -d 255.255.255.255/32 -o wlp4s0 -j RETURN
$IPT -A LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -p tcp -j MASQUERADE --to-ports 1024-65535
$IPT -A LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -p udp -j MASQUERADE --to-ports 1024-65535
$IPT -A LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -j MASQUERADE

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
$IPT -A LIBVIRT_FWI -d 192.168.10.0/24 -i wlp4s0 -o virbr1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPT -A LIBVIRT_FWI -o virbr1 -j REJECT --reject-with icmp-port-unreachable
$IPT -A LIBVIRT_FWI -o virbr2 -j REJECT --reject-with icmp-port-unreachable
$IPT -A LIBVIRT_FWO -s 192.168.10.0/24 -i virbr1 -o wlp4s0 -j ACCEPT
$IPT -A LIBVIRT_FWO -i virbr1 -j REJECT --reject-with icmp-port-unreachable
$IPT -A LIBVIRT_FWO -i virbr2 -j REJECT --reject-with icmp-port-unreachable
$IPT -A LIBVIRT_FWX -i virbr1 -o virbr1 -j ACCEPT
$IPT -A LIBVIRT_FWX -i virbr2 -o virbr2 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr1 -p udp -m udp --dport 53 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr1 -p tcp -m tcp --dport 53 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr1 -p udp -m udp --dport 67 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr1 -p tcp -m tcp --dport 67 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr2 -p udp -m udp --dport 53 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr2 -p tcp -m tcp --dport 53 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr2 -p udp -m udp --dport 67 -j ACCEPT
$IPT -A LIBVIRT_INP -i virbr2 -p tcp -m tcp --dport 67 -j ACCEPT
$IPT -A LIBVIRT_OUT -o virbr1 -p udp -m udp --dport 68 -j ACCEPT
$IPT -A LIBVIRT_OUT -o virbr2 -p udp -m udp --dport 68 -j ACCEPT
$IPTS
exit 0
