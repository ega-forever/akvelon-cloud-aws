variable "region" {
  type = string
  default = "eu-west-1"
}

variable "app_name" {
  type = string
  default = "app"
}

variable "app_port" {
  type = number
  default = 80
}

variable "service_discovery_name" {
  type = string
  default = "app"
}

locals {
  json_data = jsondecode(file("../../result.json"))
}
