#!/bin/bash


red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$( pwd )

    echo "Please enter password for ${software[${selected}-1]}"
    read -p "(default password: teddysun.com):" shadowsockspwd
    [ -z "${shadowsockspwd}" ] && shadowsockspwd="teddysun.com"
    echo
    echo "password = ${shadowsockspwd}"
    echo

    while true
    do
    echo -e "Please enter a port for ${software[${selected}-1]} [1-65535]"
    read -p "(default port: 8989):" shadowsocksport
    [ -z "${shadowsocksport}" ] && shadowsocksport="8989"
    expr ${shadowsocksport} + 0 &>/dev/null
    if [ $? -eq 0 ]; then
        if [ ${shadowsocksport} -ge 1 ] && [ ${shadowsocksport} -le 65535 ]; then
            echo
            echo "port = ${shadowsocksport}"
            echo
            break
        else
            echo -e "${red}Error:${plain} Please enter a correct number [1-65535]"
        fi
    else
        echo -e "${red}Error:${plain} Please enter a correct number [1-65535]"
    fi
    done

    echo
    echo "Press any key to start...or Press Ctrl+C to cancel"
    char=`get_char`



yes | apt-get install git &
git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git &
cd ./shadowsocksr &
bash initcfg.sh &

mkdir /etc/shadowsocksr
    cat > /etc/shadowsocksr/config.json <<-EOF
{
    "server":"0.0.0.0",
    "server_ipv6":"::",
    "server_port":${shadowsocksport},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":120,
    "method":"aes-256-cfb",
    "protocol":"auth_sha1_v4",
    "protocol_param":"",
    "obfs":"http_simple",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":false,
    "workers":1
}
EOF
python shadowsocks/server.py -c /etc/shadowsocksr/config.json -d start

#chmod +755 /etc/init.d/shadowsocksr;update-rc.d shadowsocksr defaults;service shadowsocksr start