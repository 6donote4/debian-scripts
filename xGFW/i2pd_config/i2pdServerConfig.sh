#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Debian 11
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:This script is used to config outproxy of i2pd server and join to i2p router family on debian 11
#   Version: 0.0.1
#   Blog: https://www.donote.ml https://6donote4.github.io
#========================================
# NOTICE: Please run it to build i2pd-tools or i2pd with common user ,then configure it with root account

VERSION=0.0.1
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
args=($(getopt -o bcishv -l help,version -- "$@"))
set -- "$args";
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
usage() {
cat << EOF
$PROGNAME $VERSION
Usage:
./$PROGNAME [option]
Options
-b only build i2pd
-c only bulid i2pd-tools
-i install i2pd and tinyproxy
-s config i2pd and tinyproxy
-v --version  Show version
-h --help  Show this usage
EOF
}
if [[ "$1" == ""  ]];then
    usage
    exit 0
fi
read_fun() {
        read -p "$1" RESPON

            echo $RESPON
        }
print_fun() {
        echo -e "${yellow}You inputed :${plain}"
        echo $1 >&1
        echo -e "${green}print done${plain}"
        }
test_fun() {
    print_fun ${ARG=$(read_fun "read_print_test:" )}
    echo -e "${green}test done${plain}"
}
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
<<EOF
usage:
if [[ ${release} == "centos"   ]]; then
yum install -y debootstrap schroot
elif [[ ${release} == "debian"  ]];then
apt-get install -y debootstrap schroot
else
pacman -S debootstrap schroot
fi
EOF
	bit=`uname -m`
}
check_root(){
        [[ $EUID != 0  ]] && echo -e " ${red}当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用sudo su 来获取临时ROOT权限（执行后会提示输入当前账号的密码）。${plain}" && exit 1
}

I2PD_TOOLS_BDIR=""
I2PD_BDIR=""
I2PD_CDIR=/etc/i2pd
I2PD_GDIR=/var/lib/i2pd
TINYPROXY_CDIR=/etc/tinyproxy/

_install_i2pd(){
    apt-get install -y apt-transport-https
    wget -q -O - https://repo.i2pd.xyz/.help/add_repo | bash -s -
    apt-get update
    apt-get install -y i2pd
}

_build_i2pd-tools(){
    git clone --recursive https://github.com/purplei2p/i2pd-tools
    cd i2pd-tools
    bash i2pd-tools
    make V=s -j$(nproc)
    mkdir ../i2pd_tools_bin
    ls |file *|grep ELF|awk '{print $1}'|tr -d :|xargs -I[] mv -f [] ../i2pd_tools_bin
    cd i2pd
    make V=s -j$(nproc)
    ls |file *|grep ELF|awk '{print $1}'|tr -d :|xargs -I[] mv -f [] ../../i2pd_tools_bin
    I2PD_TOOLS_BDIR=../../i2pd_tools_bin
    make clean
    cd ..
    make clean
    cd ..
}

_build_i2pd(){
    git clone https://github.com/PurpleI2P/i2pd.git
    cd i2pd
    make V=s -j$(nproc)
    make install
}


_config_server_conf(){
    I2PD_CDIR=/etc/i2pd
    I2PD_GDIR=/var/lib/i2pd
    mv $I2PD_CDIR/i2pd.conf $I2PD_CDIR/i2pd.conf.bak
    cat > $I2PD_CDIR/i2pd.conf <<-EOF
    {
## Specify a family, router belongs to (default - none)
family = i2pProxy #Change your router family name .for my configuration,I put i2pProxy.crt to /var/lib/i2pd/certification/family and i2pProxy.key to /var/lib/i2pd/family

## Enable communication through ipv4
ipv4 = true
## Enable communication through ipv6
ipv6 = false

## Enable SSU transport (default = true)
ssu = false

## Bandwidth configuration
## L limit bandwidth to 32KBs/sec, O - to 256KBs/sec, P - to 2048KBs/sec,
## X - unlimited
## Default is L (regular node) and X if floodfill mode enabled. If you want to
## share more bandwidth without floodfill mode, uncomment that line and adjust
## value to your possibilities
bandwidth = P
## Max % of bandwidth limit for transit. 0-100. 100 by default
share = 64

## Router will not accept transit tunnels, disabling transit traffic completely
## (default = false)
notransit = true

[ntcp2]
## Enable NTCP2 transport (default = true)
enabled = false

[ssu2]
## Enable SSU2 transport (default = false for 2.43.0)
enabled = true
## Publish address in RouterInfo (default = false for 2.43.0)
published = true
## Port for incoming connections (default is global port option value or port + 1 if SSU is enabled)
port = 4567

[http]
## Web Console settings
## Uncomment and set to 'false' to disable Web Console
# enabled = true
## Address and port service will listen on
address = 127.0.0.1
port = 7070
## Path to web console, default "/"
# webroot = /
## Uncomment following lines to enable Web Console authentication
auth = true
user = i2pd
pass = changeme
## Select webconsole language
## Currently supported english (default), afrikaans, armenian, chinese, french,
## german, russian, turkmen, ukrainian and uzbek languages
lang = english

[httpproxy]
## Uncomment and set to 'false' to disable HTTP Proxy
enabled = true
## Address and port service will listen on
address = 127.0.0.1
port = 4444
## Optional keys file for proxy local destination
# keys = http-proxy-keys.dat
## Enable address helper for adding .i2p domains with "jump URLs" (default: true)
# addresshelper = true
## Address of a proxy server inside I2P, which is used to visit regular Internet outproxy = http://exit.stormycloud.i2p
outproxy = http://127.0.0.1:8888 #tinyproxy listening port
## httpproxy section also accepts I2CP parameters, like "inbound.length" etc.

[socksproxy]
## Uncomment and set to 'false' to disable SOCKS Proxy
enabled = true
## Address and port service will listen on
address = 127.0.0.1
port = 4447
## Optional keys file for proxy local destination
# keys = socks-proxy-keys.dat
## Socks outproxy. Example below is set to use Tor for all connections except i2p
## Uncomment and set to 'true' to enable using of SOCKS outproxy
outproxy.enabled = true
## Address and port of outproxy
outproxy = 127.0.0.1
outproxyport = 9050
## socksproxy section also accepts I2CP parameters, like "inbound.length" etc.

[sam]
## Comment or set to 'false' to disable SAM Bridge
enabled = true
## Address and port service will listen on
address = 127.0.0.1
port = 7656

[bob]
## Uncomment and set to 'true' to enable BOB command channel
enabled = true
## Address and port service will listen on
address = 127.0.0.1
port = 2827

[i2cp]
## Uncomment and set to 'true' to enable I2CP protocol
enabled = true
## Address and port service will listen on
address = 127.0.0.1
port = 7654

[i2pcontrol]
## Uncomment and set to 'true' to enable I2PControl protocol
# enabled = true
## Address and port service will listen on
# address = 127.0.0.1
# port = 7650
## Authentication password. "itoopie" by default
# password = itoopie

[precomputation]
## Enable or disable elgamal precomputation table
## By default, enabled on i386 hosts
# elgamal = true

[upnp]
## Enable or disable UPnP: automatic port forwarding (enabled by default in WINDOWS, ANDROID)
# enabled = true
## Name i2pd appears in UPnP forwardings list (default = I2Pd)
# name = I2Pd

[meshnets]
## Enable connectivity over the Yggdrasil network
# yggdrasil = false
## You can bind address from your Yggdrasil subnet 300::/64
## The address must first be added to the network interface
# yggaddress =

[reseed]
## Options for bootstrapping into I2P network, aka reseeding
## Enable or disable reseed data verification.
verify = true
## URLs to request reseed data from, separated by comma
## Default: "mainline" I2P Network reseeds
urls = https://reseed.i2p-projekt.de/,https://i2p.mooo.com/netDb/,https://netdb.i2p2.no/
## Reseed URLs through the Yggdrasil, separated by comma
yggurls = http://[324:9de3:fea4:f6ac::ace]:7070/
## Path to local reseed data file (.su3) for manual reseeding
# file = /path/to/i2pseeds.su3
## or HTTPS URL to reseed from
file = https://legit-website.com/i2pseeds.su3
## Path to local ZIP file or HTTPS URL to reseed from
# zipfile = /path/to/netDb.zip
## If you run i2pd behind a proxy server, set proxy server for reseeding here
## Should be http://address:port or socks://address:port
# proxy = http://127.0.0.1:8118
## Minimum number of known routers, below which i2pd triggers reseeding. 25 by default
# threshold = 25

[addressbook]
## AddressBook subscription URL for initial setup
## Default: reg.i2p at "mainline" I2P Network
defaulturl = http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt
## Optional subscriptions URLs, separated by comma
subscriptions = http://reg.i2p/hosts.txt,http://identiguy.i2p/hosts.txt,http://stats.i2p/cgi-bin/newhosts.txt,http://rus.i2p/hosts.txt

[limits]
## Maximum active transit sessions (default:2500)
# transittunnels = 2500
## Limit number of open file descriptors (0 - use system limit)
# openfiles = 0
## Maximum size of corefile in Kb (0 - use system limit)
# coresize = 0

[trust]
## Enable explicit trust options. false by default
enabled = true
## Make direct I2P connections only to routers in specified Family.
family = i2pProxy
## Make direct I2P connections only to routers specified here. Comma separated list of base64 identities.
# routers =
## Should we hide our router from other routers? false by default
# hidden = true
    }
EOF

    cat > $I2P_CDIR/tunnels.conf.d/proxy.conf <<-EOF
    {
[MyOutProxy]
type = server
host = 127.0.0.1
port = 8888
keys = myoutproxy-keys.dat
signaturetype = 7
inbound.length = 1
outbound.length = 1
    }
EOF
    cd $I2PD_TOOLS_BDIR
    ./keygen myoutproxy-keys.dat
    ./keyinfo -v myoutproxy-keys.dat > myoutproxy-keys.alladdrinfo
    cp -f myoutproxy-keys.dat myouotproxy-keys.alladdrinfo $I2P_GDIR
    cd -
}
_install_tinyproxy(){
    apt-get update
    apt-get install -y tinyproxy
}
_conf_tinyproxy(){
    mv $TINYPROXY_CDIR/tinyproxy.conf $TINYPROXY_CDIR/tinyproxy.conf.bak
    cat > $TINYPROXY_CDIR <<-EOF
    {
User tinyproxy
Group tinyproxy
Port 8888
Listen 127.0.0.1
Timeout 600
DefaultErrorFile "/usr/share/tinyproxy/default.html"
MaxClients 100
LogLevel Warning
PidFile "/run/tinyproxy/tinyproxy.pid"
MinSpareServers 5
MaxSpareServers 20
StartServers 10
MaxRequestsPerChild 0
Allow 127.0.0.1/8
ViaProxyName "tinyproxy"
Filter "/etc/tinyproxy/filter"
FilterExtended On
ConnectPort 443
    }
EOF
    cat > $TINYPROXY_CDIR/filter <<-EOF
    {
^127\.
^10\.
    }
EOF
}

main(){
    usage
}

while [ -n "$1" ]
do
	case "$1" in
        -b)
            _build_i2pd
            exit 0
            ;;
        -c)
            _build_i2pd-tools
            exit 0
            ;;
        -i)
            _install_i2pd
            _install_tinyproxy
            exit 0
            ;;
        -s)
            _build_i2pd
            _build_i2pd_tools
            _config_server_conf
            _conf_tinyproxy
            systemctl restart i2pd tinyproxy
            rm -rf $I2PD_BDIR
            rm -rf $I2PD_TOOLS_BDIR
            exit 0
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            echo $VERSION
            exit 0
            ;;
        --)
            main
            ;;
        *)
            echo -e "${red}Invalid parameter $1 ${plain}" 1>&2
            break
            ;;
	esac
    shift
done
