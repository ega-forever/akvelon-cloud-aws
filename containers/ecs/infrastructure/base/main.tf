provider "aws" {
  region = var.region
  version = "3.5.0"
}

data "aws_region" "current" {}

output "vpc_public_subnet" {
  value = aws_subnet.public.id
}

output "vpc_public_subnet2" {
  value = aws_subnet.public2.id
}

output "vpc_private_subnet" {
  value = aws_subnet.private.id
}

output "vpc_private_subnet2" {
  value = aws_subnet.private2.id
}

output "vpc" {
  value = aws_vpc.default.id
}

output "rds_address" {
  value = aws_db_instance.db.address
}

output "rds_username" {
  value = var.db_username
}

output "rds_password" {
  value = var.db_password
}

output "rds_db" {
  value = var.db_name
}

output "ecs_cluster" {
  value = aws_ecs_cluster.gql.id
}

output "task_role" {
  value = aws_iam_role.task-role.arn
}

output "main_ecs_role" {
  value = aws_iam_role.main-ecs-tasks.arn
}
