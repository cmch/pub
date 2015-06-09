yum -y update
yum -y install ruby20 ruby20-devel rubygems20-devel gcc patch zlib-devel httpd24
gem install nokogiri aws-sdk
chmod 644 /home/ec2-user/pitchfork-csv/pitchfork-csv.cron
chown root /home/ec2-user/pitchfork-csv/pitchfork-csv.cron
ln -sf /home/ec2-user/pitchfork-csv/pitchfork-csv.cron /etc/cron.d/pitchfork-csv.cron
chkconfig httpd on
groupadd www
usermod -a -G www ec2-user
ln -sf /home/ec2-user/pitchfork-csv/web /var/www/html/web
ln -sf /home/ec2-user/pitchfork-csv/web/index.html /var/www/html/index.html
chmod o+x /home/ec2-user /home/ec2-user/pitchfork-csv /home/ec2-user/pitchfork-csv/web
chown -R root:www /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} +
find /var/www -type f -exec chmod 0664 {} +
service httpd start
