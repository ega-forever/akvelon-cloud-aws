resource "aws_security_group" "lab-counter-public-access-sg" {
  description = "Enable HTTP access via port 80 + SSH access"
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "lab-counter-web-server" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name = var.ec2_keypair_name
  depends_on = [aws_security_group.lab-counter-public-access-sg, aws_db_instance.lab-counter-db]
  vpc_security_group_ids = [aws_security_group.lab-counter-public-access-sg.id]
  tags = {
    Lab = "true"
  }
  user_data = <<-EOT
    #!/bin/bash

    curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
    sudo yum update -y && sudo yum install -y nodejs npm git
    git clone https://github.com/andreich78-20/akvelon-cloud-aws.git akvelon-web-server
    cd akvelon-web-server/ec2/app
    npm install
    npm install -y mysql
    sudo npm install -g pm2
    DB_USERNAME=${var.db_username} DB_PASSWORD=${var.db_password} DB_NAME=${var.db_name} DB_ENDPOINT=${aws_db_instance.lab-counter-db.address} pm2 start index.js
    pm2 startup systemd
    pm2 save
  EOT

}
