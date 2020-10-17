resource "aws_autoscaling_group" "webservice_asg" {
  vpc_zone_identifier = var.subnets
  launch_configuration = aws_launch_configuration.wordpress.id
  max_size = 5
  min_size = 2
  desired_capacity = 2
  target_group_arns = [aws_lb_target_group.alb_target_group.id]
}