#!/bin/bash
list=$(ls *.xspf)
TPATH=$(pwd)
OLD=bullseye-a0978f64-29ae-401b-947e-35a105714d7b
NEW=$(cat /home/dzc/btsync.session)
for i in $list
do
    cat $i|sed  "s/$OLD/$NEW/g" > $TPATH/NEW/$i
    cp -rf $TPATH/NEW/$i .
done
exit 0
