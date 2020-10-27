variable "ec2_keypair_name" {
  type    = string
  default = "app_keypair"
}

variable "ec2_ami" {
  type    = string
  default = "ami-0701e7be9b2a77600" # ubuntu image
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.small"
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "loggroup_name" {
  type    = string
  default = ""
}

variable "logstream_name" {
  type    = string
  default = ""
}

variable "first_queue" {
  type    = string
  default = ""
}

variable "second_queue" {
  type    = string
  default = ""
}

variable "sns_topic_name" {
  type    = string
  default = ""
}
