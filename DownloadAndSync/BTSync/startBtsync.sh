#!/bin/bash
#HOME=/home/
#export HOME
$HOME/loadDisk.sh
$HOME/Btsync/btsync --config $HOME/Btsync/btsync.conf
$HOME/Rslsync/rslsync --config $HOME/Rslsync/rslsync.conf
exit 0
