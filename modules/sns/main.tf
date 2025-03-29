resource "aws_sns_topic" "events_sns_topic" {
    name = var.sns_topic_name
  
}

resource "aws_sns_topic_subscription" "sns_to_sqs_subscription" {
    topic_arn = aws_sns_topic.events_sns_topic.arn
    protocol = "sqs"
    endpoint = var.sqs_queue_arn

    filter_policy = jsonencode({
        eventtype = ["trigger"]
    })
  
}
