resource "aws_sns_topic" "fanout_topic" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "first_queue_sqs_target" {
  topic_arn = aws_sns_topic.fanout_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.first_queue.arn
}

resource "aws_sns_topic_subscription" "second_queue_sqs_target" {
  topic_arn = aws_sns_topic.fanout_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.second_queue.arn
}
