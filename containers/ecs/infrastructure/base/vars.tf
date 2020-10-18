variable "region" {
  type = string
  default = "eu-west-1"
}

variable "ecs_cluster_name" {
  type    = string
  default = "gql-cluster"
}

variable "db_instance_type" {
  type    = string
  default = "db.t2.small"
}

variable "db_username" {
  type    = string
  default = "app_user"
}

variable "db_password" {
  type    = string
  default = "abc123456"
}

variable "db_name" {
  type    = string
  default = "app_db"
}

variable "db_allocated_storage" {
  type = number
  default = 5
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_public_subnet_cidr" {
  type = string
  default = "10.0.0.0/24"
}

variable "vpc_public_subnet_az" {
  type = string
  default = "eu-west-1b"
}

variable "vpc_public_subnet2_cidr" {
  type = string
  default = "10.0.3.0/24"
}

variable "vpc_public_subnet2_az" {
  type = string
  default = "eu-west-1c"
}

variable "vpc_private_subnet_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "vpc_private_subnet_az" {
  type = string
  default = "eu-west-1c"
}

variable "vpc_private_subnet2_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "vpc_private_subnet2_az" {
  type = string
  default = "eu-west-1a"
}
