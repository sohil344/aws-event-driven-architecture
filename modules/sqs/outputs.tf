output "sqs_queue_arn" {
    value = aws_sqs_queue.event_sqs_queue.arn
  
}

output "sqs_queue_url" {
    value = aws_sqs_queue.event_sqs_queue.url
  
}