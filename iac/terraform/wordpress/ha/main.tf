provider "aws" {
  region = "eu-west-1"
  version = "3.5.0"
}

output "website" {
  value = aws_lb.application_load_balancer.dns_name
}
