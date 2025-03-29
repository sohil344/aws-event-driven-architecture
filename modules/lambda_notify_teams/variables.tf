variable "teams_webhook_url" {
  description = "Microsoft Teams Webhook URL"
  type        = string
}

variable "lambda_name" {
    description = "Lambda function name"
    type = string
  
}

variable "lambda_role_arn" {
    description = "Role ARN"
    type = string
    default = ""
}