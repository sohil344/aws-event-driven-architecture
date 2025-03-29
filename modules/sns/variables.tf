variable "sns_topic_name" {
    description = "Name of sns topic"
    type = string
  
}

variable "sqs_queue_arn" {

    description = "ARN of the SQS queue for SNS subscription"
    type = string
  
}

