provider "aws" {
  region = "us-west-2"
  version = "3.5.0"
}

module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

output "website" {
  value = aws_instance.Wordpress.public_dns
}
