#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Client end."
echo "Client is Receiving a directory....."
echo "Please send a directory from dirsender_in_ncserver."
echo "Please input TargetIPaddr and Port."
nc -nv $1 $2|tar xvf -
exit 0
