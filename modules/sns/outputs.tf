output "sns_topic_arn" {
  
  value = aws_sns_topic.events_sns_topic.arn
}