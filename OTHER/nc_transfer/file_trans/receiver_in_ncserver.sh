#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Server end."
echo "Server is Receiving a file....."
echo "Please send a file from sender_in_ncclient."
echo "Please input LocalPort and Outfile"
nc -l -p $1 > $2
exit 0
