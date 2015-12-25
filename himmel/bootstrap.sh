apt-get -y update
apt-get -y install apache2
ln -sf /project/web /var/www/html/web
service apache2 start
