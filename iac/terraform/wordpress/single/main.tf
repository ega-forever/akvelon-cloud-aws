provider "aws" {
  region = "eu-west-1"
  version = "3.5.0"
}

output "website" {
  value = aws_instance.wordpress.public_dns
}
