#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Client end."
echo "Client is Receiving a media stream....."
echo "Please send a media stream from sender_in_ncserver."
echo "Please input TargetIPaddr,Port."
nc -nv $1 $2 |mplayer -vo x11 -cache 3000 -
exit 0
