#!/bin/sh
#acconnect -i to find ALSA midi ID and write it to configuraion midiconfig=;
# for cd dosgame :
# sudo mount -o loop rom.iso mntDir
# autoexec section in dosbox.conf file:
# mount d mntDir -t cdrom
# mount c dosgame -freesize 1000[unit:Mb]
dosbox -conf dosbox-0.74-3.conf
exit 0
