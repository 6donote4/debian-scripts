#!/bin/bash
export PATH=$PATH:/sbin:/usr/sbin
echo "This is Server end."
echo "Server is Receiving a media stream....."
echo "Please send a media stream from sender_in_ncclient."
echo "Please input listenning Port "
nc -lp $1|mplayer -vo x11 -cache 3000 -
exit 0
