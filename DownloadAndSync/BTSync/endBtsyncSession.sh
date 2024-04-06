#!/bin/bash
THOME="/home/user"
USER="user"
PASSWD="123456"
BSESSION=$(echo $PASSWD|sudo -S -u $USER schroot -l --all-sessions)
echo $BSESSION
echo $PASSWD | sudo -S schroot -e -c $BSESSION
sleep 20
echo $PASSWD | sudo -S schroot -e -c $BSESSION
exit 0
