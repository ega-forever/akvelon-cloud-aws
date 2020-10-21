resource "aws_ecs_task_definition" "app" {
  family = var.app_name
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn = local.json_data.task_role.value # the role used by task itself, like logging to cloudwatch
  execution_role_arn = local.json_data.main_ecs_role.value # the role for executing certain actions over task, like pulling image
  cpu = "256"
  memory = "512"
  container_definitions = jsonencode([
    {
      name: "app",
      image: "${aws_ecr_repository.app.repository_url}:latest",
      memory: 512,
      networkMode : "awsvpc",
      environment: [
        {name: "DB_PASSWORD", value: local.json_data.rds_password.value},
        {name: "DB_USER", value: local.json_data.rds_username.value},
        {name: "DB_DB", value: local.json_data.rds_db.value},
        {name: "DB_HOST", value: local.json_data.rds_address.value},
        {name: "LOG_LEVEL", value: "30"},
        {name: "GQL_INTROSPECTION", value: "1"},
        {name: "GQL_PLAYGROUND", value: "1"},
        {name: "REST_PORT", value: tostring(var.app_port)}
      ],
      portMappings: [
        {
          containerPort: var.app_port,
          protocol: "tcp",
          hostPort: var.app_port
        }
      ],
      logConfiguration: {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": aws_cloudwatch_log_group.app_lg.name,
          "awslogs-region": var.region,
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name                = "app"
  cluster             = local.json_data.ecs_cluster.value
  task_definition     = aws_ecs_task_definition.app.arn
  force_new_deployment = true
  desired_count = 2
  launch_type = "FARGATE"
  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.app_sg.id]
    subnets = [local.json_data.vpc_public_subnet.value, local.json_data.vpc_public_subnet2.value]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "app"
    container_port   = var.app_port
  }
  service_registries {
    registry_arn = aws_service_discovery_service.fargate.arn
    port = var.app_port
  }
}
