resource "aws_service_discovery_private_dns_namespace" "service_discovery" {
  name = var.service_discovery_namespace
  vpc = aws_vpc.default.id
  description = "Fargate discovery managed zone."
}
