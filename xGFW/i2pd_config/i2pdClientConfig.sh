#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Debian 11
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:This script is used to config i2pd clent and join to i2p family on debian 11
#   Version: 0.0.1
#   Blog: https://www.donote.ml https://6donote4.github.io
#========================================
# NOTICE: Please place family-*-secret.crt in the directory where the script file is in.

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

$I2PD_CDIR=/etc/i2pd
$I2PD_GDIR=/var/lib/i2pd
_config(){
    head -n 4 family-*.crt > i2pProxy.key
    tail -n 14 family-*.crt > i2pProxy.crt
    mv -f i2pProxy.key $I2PD_GDIR/family
    mv -f i2pProxy.crt $I2PD_GDIR/certifications/family
    mv $I2PD_CDIR/i2pd.conf $I2PD_CDIR/i2pd.conf.bak
    touch $I2PD_GDIR/addressbook/local.csv
    cat > $I2PD_CDIR/i2pd.conf <<-EOF
    {
## Logging configuration section
## By default logs go to stdout with level 'info' and higher
## For Windows OS by default logs go to file with level 'warn' and higher
##
## Logs destination (valid values: stdout, file, syslog)
##  * stdout - print log entries to stdout
##  * file - log entries to a file
##  * syslog - use syslog, see man 3 syslog
# log = file
## Path to logfile (default - autodetect)
logfile = /var/log/i2pd/i2pd.log
## Log messages above this level (debug, info, *warn, error, none)
## If you set it to none, logging will be disabled
# loglevel = warn
## Write full CLF-formatted date and time to log (default: write only time)
# logclftime = true

## Daemon mode. Router will go to background after start. Ignored on Windows
# daemon = true

## Specify a family, router belongs to (default - none)
family = i2pProxy



## Enable communication through ipv4
ipv4 = true
## Enable communication through ipv6
ipv6 = false


## Bandwidth configuration
## L limit bandwidth to 32KBs/sec, O - to 256KBs/sec, P - to 2048KBs/sec,
## X - unlimited
## Default is L (regular node) and X if floodfill mode enabled. If you want to
## share more bandwidth without floodfill mode, uncomment that line and adjust
## value to your possibilities
bandwidth = O
## Max % of bandwidth limit for transit. 0-100. 100 by default
# share = 100

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
# auth = true
# user = i2pd
# pass = changeme
## Select webconsole language
## Currently supported english (default), afrikaans, armenian, russian,
## turkmen, ukrainian and uzbek languages
# lang = english

[httpproxy]
## Uncomment and set to 'false' to disable HTTP Proxy
enabled = true
## Address and port service will listen on
#address = 0.0.0.0
port = 4444
## Optional keys file for proxy local destination
# keys = http-proxy-keys.dat
## Enable address helper for adding .i2p domains with "jump URLs" (default: true)
addresshelper = true
## Address of a proxy server inside I2P, which is used to visit regular Internet
outproxy = lw4j7m3oof3mkhzx2skbvuo4nbfnbyxkojd6fxyleylhnb3qjysq.b32.i2p #I created my outproxy of i2p network,please read your site.dat file with command keyinfo
## httpproxy section also accepts I2CP parameters, like "inbound.length" etc.

[socksproxy]
## Uncomment and set to 'false' to disable SOCKS Proxy
# enabled = true
## Address and port service will listen on
#address = 127.0.0.1
#port = 4447
## Optional keys file for proxy local destination
# keys = socks-proxy-keys.dat
## Socks outproxy. Example below is set to use Tor for all connections except i2p
## Uncomment and set to 'true' to enable using of SOCKS outproxy
# outproxy.enabled = false
## Address and port of outproxy
# outproxy = 127.0.0.1
# outproxyport = 9050
## socksproxy section also accepts I2CP parameters, like "inbound.length" etc.

[sam]
## Comment or set to 'false' to disable SAM Bridge
#enabled = true
## Address and port service will listen on
# address = 127.0.0.1
# port = 7656

[bob]
## Uncomment and set to 'true' to enable BOB command channel
# enabled = true
## Address and port service will listen on
# address = 127.0.0.1
# port = 2827

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
#address = 127.0.0.1
#port = 7650
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
# yggdrasil = true
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
# file = https://legit-website.com/i2pseeds.su3
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

[exploratory]
## Exploratory tunnels settings with default values
# inbound.length = 2
# inbound.quantity = 3
# outbound.length = 2
# outbound.quantity = 3

[persist]
## Save peer profiles on disk (default: true)
# profiles = true
## Save full addresses on disk (default: true)
# addressbook = true

[cpuext]
## Use CPU AES-NI instructions set when work with cryptography when available (default: true)
# aesni = true
## Use CPU AVX instructions set when work with cryptography when available (default: true)
# avx = true
## Force usage of CPU instructions set, even if they not found
## DO NOT TOUCH that option if you really don't know what are you doing!
# force = false
    }
EOF

    cat > $I2PD_GDIR/addressbook/local.csv <<-EOF
    {
myoutproxy.i2p,lw4j7m3oof3mkhzx2skbvuo4nbfnbyxkojd6fxyleylhnb3qjysq
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
            exit 0
            ;;
        -c)
            exit 0
            ;;
        -i)
            exit 0
            ;;
        -s)
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
