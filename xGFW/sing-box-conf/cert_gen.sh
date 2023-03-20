#!/bin/bash
export PATH=$PATH:/sbin
RUN=/root/.acme.sh/acme.sh 
ACMEP=/root/.acme.sh
CERTP=/root/cert
list="trojan.donote.ml trojan-websocket.donote.ml vmess.donote.ml vmess-websocket.donote.ml naive.donote.ml"
for i in $list
do
$RUN --issue --force -d $i --standalone
	prefix=$(echo $i|awk -F. '{print $1}')
	ln -s  $ACMEP/${i}_ecc/fullchain.cer $CERTP/$prefix.ca
	ln -s  $ACMEP/${i}_ecc/${i}.key $CERTP/$prefix.key
	done
exit 0
