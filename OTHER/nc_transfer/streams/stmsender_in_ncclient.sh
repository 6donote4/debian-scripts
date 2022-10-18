#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Client end."
echo "Client is Sending a media stream....."
echo "Please receive a media stream in receiver_in_ncserver."
echo "Please input a media file name, TargetIP and Port "
cat $1 | nc -nv $2 $3
exit 0
