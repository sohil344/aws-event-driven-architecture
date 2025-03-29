output "step_functions_role_arn" {
  description = "The ARN of the step function role arn"
  value       = aws_iam_role.step_functions_role.arn
}
