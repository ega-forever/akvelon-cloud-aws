output "website" {
  value = aws_lb.application_load_balancer.dns_name
}
