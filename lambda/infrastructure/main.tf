provider "aws" {
  region = "eu-west-1"
  version = "3.5.0"
}

data "aws_region" "current" {}

output "lambda_url" {
  value = "${aws_api_gateway_deployment.app-lambda-deployment.invoke_url}/${var.function_name}"
}
