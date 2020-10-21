resource "aws_service_discovery_service" "fargate" {
  name = var.service_discovery_name

  dns_config {
    namespace_id = local.json_data.service_discovery_namespace_id.value
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl = 10
      type = "A"
    }

    dns_records {
      ttl  = 10
      type = "SRV"
    }
  }
  health_check_custom_config {
    failure_threshold = 5
  }
}
