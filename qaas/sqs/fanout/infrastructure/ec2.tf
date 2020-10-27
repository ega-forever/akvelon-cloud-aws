resource "aws_security_group" "app_sg" {
  description = "Enable HTTP access via port 80 locked down to the load balancer + SSH access"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
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

resource "aws_instance" "app" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name = var.ec2_keypair_name
  depends_on = [aws_security_group.app_sg]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile = aws_iam_instance_profile.app_cloudwatch_role_profile.name

  user_data = <<-EOT
  #!/bin/bash

  curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  apt-get install -y nodejs
  npm install -g pm2
  git clone https://github.com/ega-forever/akvelon-cloud-aws.git ~/app
  cd ~/app/qaas/sqs/dlq/app && npm install && npm run build && \
  echo 'module.exports = {
    apps : [
        {
          name: "myapp",
          script: "./build/index.js",
          watch: false,
          env: {
              "LOGS_REGION": "${data.aws_region.current.name}",
              "LOGS_API_VERSION": "2014-03-28",
              "LOGS_GROUP": "${aws_cloudwatch_log_group.app_lg.name}",
              "LOGS_STREAM": "${aws_cloudwatch_log_stream.app_log_stream.name}",
              "SQS_FIRST_QUEUE": "${aws_sqs_queue.first_queue.id}",
              "SQS_SECOND_QUEUE": "${aws_sqs_queue.second_queue.id}",
              "SQS_REGION": "${data.aws_region.current.name}"
          }
        }
    ]
  }' > ecosystem.config.js && \
  sudo pm2 startup ubuntu && sudo pm2 start ecosystem.config.js && sudo pm2 save

  EOT

}
