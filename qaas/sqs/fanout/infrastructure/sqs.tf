#data "aws_iam_policy_document" "sqs-allow-sns-policy-inline" {
#  statement {
#    actions = [
#      "sqs:SendMessage"]
#    resources = [aws_sns_topic.fanout_topic.arn]
#  }
#}


resource "aws_sqs_queue_policy" "first_queue_policy" {
  queue_url = aws_sqs_queue.first_queue.id

  policy = <<POLICY
  {
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.first_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.fanout_topic.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "second_queue_policy" {
  queue_url = aws_sqs_queue.second_queue.id

  policy = <<POLICY
  {
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.second_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.fanout_topic.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue" "first_queue" {
  name = var.first_queue
  fifo_queue = false
  #policy = data.aws_iam_policy_document.sqs-allow-sns-policy-inline.json
}

resource "aws_sqs_queue" "second_queue" {
  name = var.second_queue
  fifo_queue = false
  ##policy = data.aws_iam_policy_document.sqs-allow-sns-policy-inline.json
}
