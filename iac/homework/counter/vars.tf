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
  default = "ami-0528a5175983e7f28" # AWS Linux 2
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "db_instance_type" {
  type    = string
  default = "db.t2.micro"
}

variable "ssh_location" {
  type    = string
  default = "0.0.0.0/0"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  default = "database2721828"
}

variable "db_name" {
  type    = string
  default = "cloud_test"
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
  type    = list(string)
  default = ["subnet-4ee63436","subnet-05ae514f"]
}