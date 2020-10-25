data "aws_iam_policy_document" "lambda-function-sts-policy-inline" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda-function-logs-policy-inline" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "lambda-function-logs-policy" {
  policy = data.aws_iam_policy_document.lambda-function-logs-policy-inline.json
}

resource "aws_iam_role" "lambda-function-role" {
  name = "lambda_function_role"
  assume_role_policy = data.aws_iam_policy_document.lambda-function-sts-policy-inline.json
}


resource "aws_iam_role_policy_attachment" "lambda-function-logs" {
  role = aws_iam_role.lambda-function-role.name
  policy_arn = aws_iam_policy.lambda-function-logs-policy.arn
}
