#!/bin/bash
user="user"
pass="pass"
ip="ip"

curl http://$ip:$port/cgi-bin/telnetenable.cgi?telnetenable=1

{
	sleep 1
	echo "$user"
	sleep 1
	echo "$pass"
	for i in $(seq 1 2)
	do
		sleep 10
		echo "reboot"
	done
}|telnet $ip

exit 0
