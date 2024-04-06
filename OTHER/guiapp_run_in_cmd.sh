#!/bin/bash
source /home/USER/.profile
export PATH=$PATH:/sbin:/usr/bin:/bin
export DISPLAY=:3
export XAUTHORITY=/home/USER/.Xauthority
#export $(dbus-lauch)
cvlc /home/USER/MUSIC.xspf > /home/USER/error.log 2>&1
#firefox https://www.bing.com > ~/error.log 2>&1
exit 0
