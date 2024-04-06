#!/bin/sh
#HOME=/home/user
#export HOME
#sudo mount -t ntfs-3g UUID=CA204D64204D5899 $HOME/MyNas
#sudo mount -t ntfs-3g UUID=02608207608201A1 $HOME/MyNas
sudo mount -t exfat-fuse UUID=ADF6-4CC8 $HOME/MyNas
exit 0
