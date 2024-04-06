#!/bin/bash
#apt update;apt install tigervnc-standalone-server tightvncserver xterm x11-xserver-utils jwm
#X windows manager:1.jwm 2.kwin-x11(qt)
USER=root vncserver :1 -localhost no -xstartup jwm
exit 0
