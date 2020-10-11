resource "aws_cloudwatch_log_group" "app_lg" {
  name = var.loggroup_name
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  log_group_name = aws_cloudwatch_log_group.app_lg.name
  name = var.logstream_name
  depends_on = [aws_cloudwatch_log_group.app_lg]
}
