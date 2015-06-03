yum update
yum -y install ruby20 ruby20-devel rubygems20-devel gcc patch zlib-devel
gem install nokogiri aws-sdk
ln -sf /home/ec2-user/pitchfork-csv.cron /etc/cron.d/pitchfork-csv.cron
