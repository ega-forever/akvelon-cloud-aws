data "aws_iam_policy_document" "app-cloudwatch-policy-inline" {
  statement {
    actions = ["logs:PutLogEvents"]
    resources = [aws_cloudwatch_log_stream.app_log_stream.arn]
  }
  statement {
    actions = ["logs:DescribeLogStreams"]
    resources = ["*"]
  }
  statement {
    actions = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage"]
    resources = [aws_sqs_queue.source_queue.arn, aws_sqs_queue.dlq_queue.arn]
  }
}

data "aws_iam_policy_document" "instance-assume-role-policy-inline" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "app-role-policy" {
  name = "app-role-policy"
  role = aws_iam_role.app_cloudwatch_role.id
  policy = data.aws_iam_policy_document.app-cloudwatch-policy-inline.json
}

resource "aws_iam_role" "app_cloudwatch_role" {
  name = "app_cloudwatch_role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy-inline.json
}

resource "aws_iam_instance_profile" "app_cloudwatch_role_profile" {
  name = "test_profile"
  role = aws_iam_role.app_cloudwatch_role.name
}
