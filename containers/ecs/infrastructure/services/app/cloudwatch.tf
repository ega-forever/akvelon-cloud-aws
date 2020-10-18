resource "aws_cloudwatch_log_group" "app_lg" {
  name = var.app_name
}
