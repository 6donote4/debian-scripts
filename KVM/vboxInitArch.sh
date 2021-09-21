#!/bin/sh
sudo pacman -Ss virtualbox
sudo modprobe vboxdrv
sudo vboxreload
exit 0
