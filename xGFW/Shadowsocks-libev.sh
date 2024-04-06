#!/bin/bash
vim /etc/apt/sources.list
yes|apt-get install shadowsocks-libev libcork16 libcorkipset1 libev4 libmbedcrypto0 libsodium18 libudns0
vim /etc/init.d/shadowsocks
vim /etc/default/shadowsocks
