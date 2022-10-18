#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Server end."
echo "Server is Sending a media stream....."
echo "Please receive a media stream in receiver_in_ncclient."
echo "Please input a media file name and listenning Port "
cat $1 |nc -lp $2
exit 0
