variable "ec2_keypair_name" {
  type    = string
  default = "wordpress_keypair"
}

variable "ec2_ami" {
  type    = string
  default = "ami-003634241a8fcdec0" # us-west-2 ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200408
  #default = "ami-0f56279347d2fa43e" # us-west-1 ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200408
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "db_instance_type" {
  type    = string
  default = "db.t2.micro"
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

variable "VpcCIDR" {
  description = "IP range (CIDR notation) for this VPC"
  type    = string
  default = "10.192.0.0/16"
}

variable "PublicSubnet1CIDR" {
  description = "IP range (CIDR notation) for the public subnet in the first Availability Zone"
  type    = string
  default = "10.192.10.0/24"
}

variable "PublicSubnet2CIDR" {
  description = "IP range (CIDR notation) for the public subnet in the second Availability Zone"
  type    = string
  default = "10.192.11.0/24"
}

variable "PrivateSubnet1CIDR" {
  description = "IP range (CIDR notation) for the private subnet in the first Availability Zone"
  type    = string
  default = "10.192.20.0/24"
}

variable "PrivateSubnet2CIDR" {
  description = "IP range (CIDR notation) for the private subnet in the second Availability Zone"
  type    = string
  default = "10.192.21.0/24"
}

variable "GlobalTagName" {
  description = "Tag name to attach to every resource created"
  type    = string
  default = "Stack"
}

variable "GlobalTagValue" {
  description = "Tag value to attach to every resource created"
  type    = string
  default = "VPC-stack-02-tf"
}
