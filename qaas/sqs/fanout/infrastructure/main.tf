provider "aws" {
  region = "eu-west-1"
  version = "3.5.0"
}

data "aws_region" "current" {}

data "aws_canonical_user_id" "current" {}

output "app_instance" {
  value = aws_instance.app.public_ip
}
