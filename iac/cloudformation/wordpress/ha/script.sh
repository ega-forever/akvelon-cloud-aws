#!/bin/bash -x
# Install the files and packages from the metadata
apt-get update -y
apt-get install -y python-pip
apt-get install -y python-setuptools
mkdir -p /opt/aws/bin
python /usr/lib/python2.7/dist-packages/easy_install.py --script-dir /opt/aws/bin https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
/opt/aws/bin/cfn-init -v --stack ${AWS::StackName} --resource EC2 --configsets setup --region ${AWS::Region}
/opt/aws/bin/cfn-signal -e --stack ${AWS::StackName} --resource EC2 --configsets setup --region ${AWS::Region}
sudo apt-get update
sudo apt-get install -y php7.2-fpm nginx-full php-mysql
sudo mkdir -p /var/www/wordpress
curl -L http://wordpress.org/latest.tar.gz > wordpress.tar.gz
sudo tar -zxf wordpress.tar.gz -C /var/www/
sudo rm /etc/nginx/sites-available/default
echo 'server {
listen 80 default_server;
listen [::]:80 default_server;
root /var/www/wordpress;
index index.php index.html index.htm;
server_name _;
location / {
try_files $uri $uri/ =404;
}
location ~ .php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
}
}' > default
sudo cp default /etc/nginx/sites-available/
sudo service php7.2-fpm restart
sudo service nginx restart
sudo cp /var/www/wordpress/wp-config-sample.php
/var/www/wordpress/wp-config.php
sudo sed -i "s/'database_name_here'/'${Ref::DBName}'/g" /var/www/wordpress/wp-config.php
sudo sed -i "s/'username_here'/'${Ref::DBUser}'/g" /var/www/wordpress/wp-config.php
sudo sed -i "s/'password_here'/'${Ref::DBPassword}'/g" /var/www/wordpress/wp-config.php
sudo sed -i "s/'localhost'/'${Fn::GetAtt:["DBInstance", "Endpoint.Address"]}'/g" /var/www/wordpress/wp-config.php