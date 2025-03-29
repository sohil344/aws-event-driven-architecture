variable "role_arn" {
  description = "IAM Role ARN for Step Functions"
  type        = string
}

variable "lambda_arn" {
  description = "Lambda function ARN"
  type        = string
}

variable "lambda_notify_teams_arn" {
  description = "ARN of the Lambda function to notify Teams"
  type        = string
}