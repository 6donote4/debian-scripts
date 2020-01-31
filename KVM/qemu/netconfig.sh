#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
pacman -S brctl
net_interface1="enp1s0"
net_interface2="enp2s0"
ip addr del 192.168.1.111/24 dev $net_interface1
ip addr del 192.168.1.112/24 dev $net_interface2
ip link add name br0 bridge
ip link add name br1 bridge
brctl addif br0 $net_interface1
brctl addif br1 $net_interface2
ip link set br0 up
ip link set br1 up
ip addr add 192.168.1.33/24 dev br0
exit 0

