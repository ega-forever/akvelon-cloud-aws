variable "ec2_keypair_name" {
  type    = string
  default = "wordpress_keypair"
}

variable "ec2_ami" {
  type    = string
  default = "ami-0701e7be9b2a77600" # ubuntu image
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.small"
}

variable "db_instance_type" {
  type    = string
  default = "db.t2.small"
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
  default = ""
}
