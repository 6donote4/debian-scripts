#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Manjaro/Debian 8+/
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription:Generate a btsync configuration file.
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
#
VERSION=0.0.1
PROGNAME="$(basename $0)"
export LC_ALL=C
SCRIPT_UMASK=0122
umask $SCRIPT_UMASK
args=($(getopt -o gtvh -l help,version,generate -- "$@"))
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
-g --generate Generate a Btsync configure
--
-t
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


WriteConfigurationFile()
{
    print_fun ${PWDDIR=$(pwd)}
    print_fun ${DEVICENAME=$(read_fun "Please input your device name:")}
    print_fun ${BTSYNCDIR=$(read_fun "Please input your Btsync directory:")}
    print_fun ${LOGINUSER=$(read_fun "Please input your Btsync web login username:")}
    print_fun ${USERPASSWORD=$(read_fun "Please set your login user password:")}
    print_fun ${OPENPORT=$(read_fun "Please set your btsync web port(1~65535):")}
    cat > btsync.conf<<-EOF
{
  "device_name": "$DEVICENAME",
  "listening_port" : 0, // 0 - randomize port

/* storage_path dir contains auxilliary app files if no storage_path field: .sync dir created in the directory
   where binary is located. otherwise user-defined directory will be used */
"storage_path" : "$PWDDIR/$BTSYNCDIR/.sync",

/* set location of pid file */
 "pid_file" : "$PWDDIR/$BTSYNCDIR/btsync.pid",

/* use UPnP for port mapping */
  "use_upnp" : true,

/* limits in kB/s. 0 - no limit */
  "download_limit" : 0,
  "upload_limit" : 0,

/* proxy configuration */
// "proxy_type" : "socks4", // Valid types: "socks4", "socks5", "http_connect". Any other value means no proxy
// "proxy_addr" : "192.168.1.2", // IP address of proxy server.
// "proxy_port" : 1080,
// "proxy_auth" : false, // Use authentication for proxy. Note: only username/password for socks5 (RFC 1929) is supported, and it is not really secure
// "proxy_username" : "user",
// "proxy_password" : "password",

  "webui" :
  {
    "listen" : "0.0.0.0:$OPENPORT" // remove field to disable WebUI

/* preset credentials. Use password or password_hash */
  ,"login" : "$LOGINUSER"
  ,"password" : "$USERPASSWORD"
//  ,"password_hash" : "some_hash" // password hash in crypt(3) format
//  ,"allow_empty_password" : false // Defaults to true
/* ssl configuration */
//  ,"force_https" : true // disable http
//  ,"ssl_certificate" : "/path/to/cert.pem"
//  ,"ssl_private_key" : "/path/to/private.key"

/* directory_root path defines where the WebUI Folder browser starts (linux only). Default value is / */
  ,"directory_root" : "$PWDDIR"

/* dir_whitelist defines which directories can be shown to user or have folders added (linux only)
   relative paths are relative to directory_root setting */
//  ,"dir_whitelist" : [ "/home/user/MySharedFolders/personal", "work" ]
  }

/* !!! if you set shared folders in config file WebUI will be DISABLED !!!
   shared directories specified in config file  override the folders previously added from WebUI. */
/*,
  "shared_folders" :
  [
    {
      "secret" : "MY_SECRET_1", // required field - use --generate-secret in command line to create new secret
      "dir" : "/home/user/bittorrent/sync_test", // * required field
      "use_relay_server" : true, //  use relay server when direct connection fails
      "use_tracker" : true,
      "use_dht" : false,
      "search_lan" : true,
      "use_sync_trash" : true, // enable SyncArchive to store files deleted on remote devices
      "overwrite_changes" : false, // restore modified files to original version, ONLY for Read-Only folders
      "known_hosts" : // specify hosts to attempt connection without additional search
      [
        "192.168.1.2:44444"
      ]
    }
  ]
*/

/* Advanced preferences can be added to config file. Info is available at http://sync-help.bittorrent.com */

}
EOF
}
main(){
    usage
}

while [ -n "$1" ]
do
	case "$1" in
        -g|--generate)
            WriteConfigurationFile
            exit 0
            ;;
        -t)
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
