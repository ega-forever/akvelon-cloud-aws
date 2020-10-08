data "aws_iam_policy_document" "app-sqs-s3-role-policy" {

  statement {
    actions = ["s3:ListBucket", "s3:PutObject", "s3:GetObject", "s3:GetObjectAcl"]
    resources = [
      aws_s3_bucket.source_bucket.arn,
      aws_s3_bucket.target_bucket.arn,
      "${aws_s3_bucket.source_bucket.arn}/*",
      "${aws_s3_bucket.target_bucket.arn}/*"
    ]
  }
  statement {
    actions = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage"]
    resources = [aws_sqs_queue.bucket_put_ev_queue.arn]
  }
}



resource "aws_iam_role_policy" "app-role-policy" {
  name = "app-role-policy"
  role = aws_iam_role.app_sqs_s3_role.id
  policy = data.aws_iam_policy_document.app-sqs-s3-role-policy.json
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "app_sqs_s3_role" {
  name = "app_sqs_s3_role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_instance_profile" "app_sqs_s3_role_profile" {
  name = "test_profile"
  role = aws_iam_role.app_sqs_s3_role.name
}
