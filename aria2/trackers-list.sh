#!/bin/bash
#CONFFILE 更改成你的conf文件真实地址
CONFFILE="/volume1/docker/Aria2NG/aria2.conf"
#DOCKERID 更改成你的Docker容器ID 在SSH使用docker ps命令查看ID
#DOCKERID="873d"
list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" $CONFFILE`" ]; then
	    sed -i '$a bt-tracker='${list} $CONFFILE
	        echo add......
		else
			    sed -i "s@bt-tracker.*@bt-tracker=$list@g" $CONFFILE
			        echo update......
fi
#docker restart -t=30 $DOCKERID
exit 0
