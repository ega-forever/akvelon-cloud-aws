data "aws_iam_policy_document" "task-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "main-ecs-tasks-role-policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "task-role" {
  name = "ecs_tasks-${var.ecs_cluster_name}-role"
  force_detach_policies = true
  assume_role_policy = data.aws_iam_policy_document.task-role-policy.json
}

resource "aws_iam_role" "main-ecs-tasks" {
  name = "main_ecs_tasks-${var.ecs_cluster_name}-role"
  force_detach_policies = true
  assume_role_policy = data.aws_iam_policy_document.task-role-policy.json
}

resource "aws_iam_role_policy" "main-ecs-tasks" {
  name = "main_ecs_tasks-${var.ecs_cluster_name}-policy"
  role = aws_iam_role.main-ecs-tasks.id
  policy = data.aws_iam_policy_document.main-ecs-tasks-role-policy.json
}
