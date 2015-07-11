apt-get -y update
apt-get -y install apache2
ln -sf /project/web /var/www/html/web
ln -sf /project/web/index.html /var/www/html/index.html
service apache2 start
