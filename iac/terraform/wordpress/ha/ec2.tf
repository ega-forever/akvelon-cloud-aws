resource "aws_security_group" "webserver_sg" {
  description = "Enable HTTP access via port 80 locked down to the load balancer + SSH access"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = aws_lb.application_load_balancer.security_groups
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [var.ssh_location]
  }
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [var.ssh_location]
  }
}

resource "aws_launch_configuration" "wordpress" {
  image_id = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name = var.ec2_keypair_name
  security_groups = [aws_security_group.webserver_sg.id]
  user_data = <<-EOT
            #!/bin/bash -x
            # Install the files and packages from the metadata
            apt-get update -y
            apt-get install -y python-pip
            apt-get install -y python-setuptools
            mkdir -p /opt/aws/bin
            python /usr/lib/python2.7/dist-packages/easy_install.py --script-dir /opt/aws/bin https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
            # /opt/aws/bin/cfn-init -v --stack $_AWS::StackName_ --resource WebServerAutoScaleGroup --configsets setup --region $_AWS::Region_
            # /opt/aws/bin/cfn-signal -e $? --stack $_AWS::StackName_ --resource WebServerAutoScaleGroup --region $_AWS::Region_
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
            sudo cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
            sudo sed -i "s/'database_name_here'/'${var.db_name}'/g" /var/www/wordpress/wp-config.php
            sudo sed -i "s/'username_here'/'${var.db_username}'/g" /var/www/wordpress/wp-config.php
            sudo sed -i "s/'password_here'/'${var.db_password}'/g" /var/www/wordpress/wp-config.php
            sudo sed -i "s/'localhost'/'${aws_db_instance.db.endpoint}'/g" /var/www/wordpress/wp-config.php
  EOT
}


