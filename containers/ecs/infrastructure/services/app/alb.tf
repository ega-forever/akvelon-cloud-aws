resource "aws_lb" "alb" {
  name = "alb-${var.app_name}"
  internal = false
  load_balancer_type = "application"
  subnets = [
    local.json_data.vpc_public_subnet.value,
    local.json_data.vpc_public_subnet2.value]
  enable_deletion_protection = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "alb_tg" {
  depends_on = [
    aws_lb.alb
  ]
  name = "alb-${var.app_name}-tg"
  port = var.app_port
  protocol = "HTTP"
  vpc_id = local.json_data.vpc.value
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.id
  port = var.app_port

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.id
    type = "forward"
  }

  depends_on = [aws_lb_target_group.alb_tg]
}
