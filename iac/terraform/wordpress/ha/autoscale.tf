resource "aws_autoscaling_group" "webservice_asg" {
  vpc_zone_identifier = [var.subnets]
  launch_configuration = aws_launch_configuration.wordpress
  max_size = 5
  min_size = 1
}