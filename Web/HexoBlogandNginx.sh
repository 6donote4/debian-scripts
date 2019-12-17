#!/bin/bash
# hexo init file
# npm install 


apt-get install nodejs -y
apt-get install nginx -y
wget https://deb.nodesource.com/setup
bash setup
apt-get install npm -y
npm install -g hexo-cli

echo "Please enter your domain1."
read domain1
echo 
echo "domainOne = $domain1"
echo

echo "Please enter your domain2."
read domain1
echo 
echo "domainOne = $domain2"
echo

echo "Please enter your ipaddress."
read ipnum
echo 
echo "ipaddress = $ipnum"
echo

echo "Please enter your account."
read account1
echo 
echo "account = $account1"
echo

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




