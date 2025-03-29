output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.notify_teams.arn
}

output "lambda_execution_role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = var.lambda_role_arn != "" ? var.lambda_role_arn : aws_iam_role.lambda_execution_role.arn
}