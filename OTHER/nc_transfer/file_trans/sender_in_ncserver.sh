#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Server end."
echo "Server is Sending a file....."
echo "Please receive a file in receiver_in_ncclient."
echo "Please input LocalPort and Infile"
nc -l -p $1 < $2
exit 0
