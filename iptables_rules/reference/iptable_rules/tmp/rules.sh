#!/bin/sh
IPT="iptables"
IPTS="iptables-save"
$IPT -t mangle -N LIBVIRT_PRT
$IPT -t mangle -A POSTROUTING -j LIBVIRT_PRT
$IPT -t mangle -A LIBVIRT_PRT -o virbr1 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
$IPT -t mangle -A LIBVIRT_PRT -o virbr2 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
$IPT -t nat -P PREROUTING -j ACCEPT
$IPT -t nat -P INPUT -j ACCEPT
$IPT -t nat -P OUTPUT -j  ACCEPT
$IPT -t nat -P POSTROUTING -j  ACCEPT
$IPT -t nat -N DOCKER
$IPT -t nat -N LIBVIRT_PRT
$IPT -t nat -P PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
$IPT -t nat -P OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
$IPT -t nat -P POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
$IPT -t nat -P POSTROUTING -j LIBVIRT_PRT
$IPT -t nat -P DOCKER -i docker0 -j RETURN
$IPT -t nat -P LIBVIRT_PRT -s 192.168.10.0/24 -d 224.0.0.0/24 -o wlp4s0 -j RETURN
$IPT -t nat -P LIBVIRT_PRT -s 192.168.10.0/24 -d 255.255.255.255/32 -o wlp4s0 -j RETURN
$IPT -t nat -P LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -p tcp -j MASQUERADE --to-ports 1024-65535
$IPT -t nat -P LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -p udp -j MASQUERADE --to-ports 1024-65535
$IPT -t nat -P LIBVIRT_PRT -s 192.168.10.0/24 ! -d 192.168.10.0/24 -o wlp4s0 -j MASQUERADE
$IPT -t filter -P INPUT -j  ACCEPT
$IPT -t filter -P FORWARD -j  DROP
$IPT -t filter -P OUTPUT -j ACCEPT
$IPT -t filter -N DOCKER
$IPT -t filter -N DOCKER-ISOLATION-STAGE-1
$IPT -t filter -N DOCKER-ISOLATION-STAGE-2
$IPT -t filter -N DOCKER-USER
$IPT -t filter -N LIBVIRT_FWI
$IPT -t filter -N LIBVIRT_FWO
$IPT -t filter -N LIBVIRT_FWX
$IPT -t filter -N LIBVIRT_INP
$IPT -t filter -N LIBVIRT_OUT
$IPT -t filter -A INPUT -j LIBVIRT_INP
$IPT -t filter -A FORWARD -j DOCKER-USER
$IPT -t filter -A FORWARD -j DOCKER-ISOLATION-STAGE-1
$IPT -t filter -A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPT -t filter -A FORWARD -o docker0 -j DOCKER
$IPT -t filter -A FORWARD -i docker0 ! -o docker0 -j ACCEPT
$IPT -t filter -A FORWARD -i docker0 -o docker0 -j ACCEPT
$IPT -t filter -A FORWARD -j LIBVIRT_FWX
$IPT -t filter -A FORWARD -j LIBVIRT_FWI
$IPT -t filter -A FORWARD -j LIBVIRT_FWO
$IPT -t filter -A OUTPUT -j LIBVIRT_OUT
$IPT -t filter -A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
$IPT -t filter -A DOCKER-ISOLATION-STAGE-1 -j RETURN
$IPT -t filter -A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
$IPT -t filter -A DOCKER-ISOLATION-STAGE-2 -j RETURN
$IPT -t filter -A DOCKER-USER -j RETURN
$IPT -t filter -A LIBVIRT_FWI -d 192.168.10.0/24 -i wlp4s0 -o virbr1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPT -t filter -A LIBVIRT_FWI -o virbr1 -j REJECT --reject-with icmp-port-unreachable
$IPT -t filter -A LIBVIRT_FWI -o virbr2 -j REJECT --reject-with icmp-port-unreachable
$IPT -t filter -A LIBVIRT_FWO -s 192.168.10.0/24 -i virbr1 -o wlp4s0 -j ACCEPT
$IPT -t filter -A LIBVIRT_FWO -i virbr1 -j REJECT --reject-with icmp-port-unreachable
$IPT -t filter -A LIBVIRT_FWO -i virbr2 -j REJECT --reject-with icmp-port-unreachable
$IPT -t filter -A LIBVIRT_FWX -i virbr1 -o virbr1 -j ACCEPT
$IPT -t filter -A LIBVIRT_FWX -i virbr2 -o virbr2 -j ACCEPT
$IPT -t filter -A LIBVIRT_INP -i virbr1 -p udp -m udp --dport 53 -j ACCEPT
$IPT -t filter -A LIBVIRT_INP -i virbr1 -p tcp -m tcp --dport 53 -j ACCEPT
$IPT -t filter -A LIBVIRT_INP -i virbr1 -p udp -m udp --dport 67 -j ACCEPT
$IPT -t filter -A LIBVIRT_INP -i virbr1 -p tcp -m tcp --dport 67 -j ACCEPT
$IPT -t filter -A LIBVIRT_INP -i virbr2 -p udp -m udp --dport 53 -j ACCEPT
$IPT -t filter -A LIBVIRT_INP -i virbr2 -p tcp -m tcp --dport 53 -j ACCEPT
$IPT -t filter -A LIBVIRT_INP -i virbr2 -p udp -m udp --dport 67 -j ACCEPT
$IPT -t filter -A LIBVIRT_INP -i virbr2 -p tcp -m tcp --dport 67 -j ACCEPT
$IPT -t filter -A LIBVIRT_OUT -o virbr1 -p udp -m udp --dport 68 -j ACCEPT
$IPT -t filter -A LIBVIRT_OUT -o virbr2 -p udp -m udp --dport 68 -j ACCEPT

$IPTS
exit 0
