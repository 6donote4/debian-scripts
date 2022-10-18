#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Client end."
echo "Client is Sending a file....."
echo "Please receive a file in receiver_in_ncserver."
echo "Please input TargetIP,Port and Infile"
nc -w3 $1 $2 < $3
exit 0
