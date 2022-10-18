#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Server end."
echo "Server is Sending a directory....."
echo "Please receive a directory in dirreceiver_in_ncclient."
echo "Please input directory name and listening Port"
tar cvf - $1/ |nc -lp $2
exit 0
