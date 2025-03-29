variable "sqs_queue_name" {
    description = "Name of the SQS Queue"
    type = string

  
}

variable "sns_topic_arn" {
    description = "ARN of the SNS topic for policy attachment"
    type = string
  
}