resource "aws_security_group" "WordpressSecurityGroup" {
  description = "Enable HTTP access via port 80 locked down to the load balancer + SSH access"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # us-west-2 does not allow HTTP requests unless the IP is whitelisted
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [join("",[tostring(module.myip.address),"/32"])]
    description = "Allow HTTP from my IP"
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.VPC.id
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "DBSubnetGroup" {
  description = "DB subnet group"
  name = "db_subnet_group"
  subnet_ids = [aws_subnet.PrivateSubnet1.id,aws_subnet.PrivateSubnet2.id]
}
resource "aws_instance" "Wordpress" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name = var.ec2_keypair_name
  depends_on = [aws_security_group.WordpressSecurityGroup, aws_security_group.DBEC2SecurityGroup, aws_db_instance.DBInstance, aws_subnet.PublicSubnet1]
  vpc_security_group_ids = [aws_security_group.WordpressSecurityGroup.id]
  subnet_id = aws_subnet.PublicSubnet1.id
  user_data = <<-EOT
              #!/bin/bash
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
              sudo sed -i "s/'localhost'/'${aws_db_instance.DBInstance.endpoint}'/g" /var/www/wordpress/wp-config.php
  EOT

}
