resource "aws_security_group" "alb_sg" {
  description = "Application Load Balancer SG"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
}

resource "aws_lb" "application_load_balancer" {
  load_balancer_type = "application"
  subnets = [var.subnets]
  security_groups = [aws_security_group.alb_sg]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  port = 80
  protocol = "HTTP"
  health_check {
    path = "/wp-admin/install.php"
    interval = 10
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 5
  }
  vpc_id = var.vpc_id
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = 30
  }
}
