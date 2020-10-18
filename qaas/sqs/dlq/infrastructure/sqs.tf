resource "aws_sqs_queue" "source_queue" {
  name = var.source_queue
  fifo_queue = false
  visibility_timeout_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_queue.arn
    maxReceiveCount = 3
  })
  depends_on = [aws_sqs_queue.dlq_queue]
}

resource "aws_sqs_queue" "dlq_queue" {
  name = var.dlq_queue
  fifo_queue = false
}
