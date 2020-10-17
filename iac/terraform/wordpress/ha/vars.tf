variable "region" {
  type    = string
  default = "us-west-2"
}

variable "ec2_keypair_name" {
  type    = string
  default = "wordpress_keypair"
}

variable "ec2_ami" {
  type    = string
  default = "ami-003634241a8fcdec0" # ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200408
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.small"
}

variable "db_instance_type" {
  type    = string
  default = "db.t2.small"
}

variable "ssh_location" {
  type    = string
  default = "0.0.0.0/0"
}

variable "db_username" {
  type    = string
  default = "user"
}

variable "db_password" {
  type    = string
  default = "abc123456"
}

variable "db_name" {
  type    = string
  default = "wordpress_db"
}

variable "db_allocated_storage" {
  type = number
  default = 5
}

variable "vpc_id" {
  type    = string
  default = "vpc-16a3e26e"
}

variable "subnets" {
  type    = list
  default = ["subnet-4ee63436","subnet-05ae514f"]
}