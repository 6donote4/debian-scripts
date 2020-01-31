#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#   Linux Distribution: Debian 10
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Version: 0.0.1
#   Description:hexo init file,npm install
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
VERSION=0.0.1
PROGNAME="$(basename $0)"

export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
cat << EOF
$PROGNAME $VERSION

Usage:
./$PROGNAME [option]
Options
-c Config Blog
--version  Show version
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
    echo "You inputed :" >&1
    echo $1 >&1
    echo "print done"
}

init_fun(
apt-get install -y nodejs nginx npm
wget https://deb.nodesource.com/setup
bash setup
npm install -g hexo-cli
)

config_fun(
domain1=$(read_fun "Please enter your domain1:")
print_fun $domain1
domain2=$(read_fun "Please enter your domain2:")
print_fun $domain2
ipnum=$(read_fun "Please enter your ipaddress:")
print_fun $ipnum
account1=$(read_fun  "Please enter your account:")
print_fun $account1
mkdir -p /var/www/blog/html
chown -R $account1 /var/www/blog/html
chmod -R 755 /var/www
cat > /etc/nginx/conf.d/blog.conf <<-EOF
	server {
		listen 80;
		listen [::]:80;

		root /var/www/blog/html;
		index index.html index.htm index.nginx-debian.html;


		server_name $domain1 $domain2 $ipnum localhost;

		location / {
		try_files $uri $uri/ =404;
				}
		}

EOF

cat >> /etc/hosts <<EOF

$ipnum	$domain1
$ipnum	$domain2

EOF

service nginx restart

)

ARGS=( "$@" )

	case "$1" in
        -r)
            init_fun
            config_fun
            exit 0
            ;;
	    -h|--help)
			usage
			exit 0
			;;
	    --version)
			echo $VERSION
			exit 0
			;;

	    *)
			echo  "Invalid parameter $1" 1>&2
			exit 1
			;;
	esac




