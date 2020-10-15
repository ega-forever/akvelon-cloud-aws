/*
data "aws_iam_policy_document" "sqs-dlq-policy-inline" {
  statement {
    actions = [
      "sqs:SendMessage"]
    resources = ["arn:aws:sqs:${data.aws_region.current.name}:${data.aws_canonical_user_id.current.id}:${var.source_queue}"]
  }
}
*/

resource "aws_sqs_queue" "source_queue" {
  name = var.source_queue
  fifo_queue = false
  visibility_timeout_seconds = 10
  redrive_policy = jsonencode({
   # deadLetterTargetArn = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_canonical_user_id.current.id}:${var.dlq_queue}"
    deadLetterTargetArn = aws_sqs_queue.dlq_queue.arn
    maxReceiveCount = 3
  })
  depends_on = [aws_sqs_queue.dlq_queue]
}

resource "aws_sqs_queue" "dlq_queue" {
  name = var.dlq_queue
  fifo_queue = false
}
