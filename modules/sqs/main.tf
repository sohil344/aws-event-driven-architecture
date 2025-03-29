resource "aws_sqs_queue" "event_sqs_queue" {
    name = var.sqs_queue_name
    message_retention_seconds = 86400
  
}

resource "aws_sqs_queue" "event_dlq" {
    name = "${var.sqs_queue_name}-dlq"
    message_retention_seconds = 1209600
  
}
resource "aws_sqs_queue_policy" "event_sqs_policy" {
  queue_url = aws_sqs_queue.event_sqs_queue.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "sns.amazonaws.com" }
      Action    = "sqs:SendMessage"
      Resource  = aws_sqs_queue.event_sqs_queue.arn
      Condition = {
        ArnEquals = {
          "aws:SourceArn" = var.sns_topic_arn
        }
      }
    }]
  })
}
