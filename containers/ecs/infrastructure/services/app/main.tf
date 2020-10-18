provider "aws" {
  region = var.region
  version = "3.5.0"
}

data "aws_region" "current" {}


output "ecr_repo" {
  value = aws_ecr_repository.app.repository_url
}

output "load_balancer" {
  value = aws_lb.alb.dns_name
}
