#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Client end."
echo "Client is Receiving a file....."
echo "Please send a file from sender_in_ncserver."
echo "Please input TargetIPaddr,Port and Outfile."
nc -w3 $1 $2 > $3
exit 0
