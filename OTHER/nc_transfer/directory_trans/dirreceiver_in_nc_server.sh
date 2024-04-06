#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Server end."
echo "Server is Receiving a directory....."
echo "Please send a directory from dirsender_in_ncclient."
echo "Please input listenning Port "
nc -lp $1 | tar xvf -
exit 0
