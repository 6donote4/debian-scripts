#!/bin/bash
#usage:./drop_ip.sh IP_address
iptables -A INPUT -p tcp -s $1 -j DROP
exit 0
