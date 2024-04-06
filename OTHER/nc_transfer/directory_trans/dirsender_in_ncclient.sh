#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Client end."
echo "Client is Sending a directory....."
echo "Please receive a directory in dirreceiver_in_ncserver."
echo "Please input directory name ,TargetIPaddr nad Port."
tar cvf - $1/ | nc -nv $2 $3
exit 0
