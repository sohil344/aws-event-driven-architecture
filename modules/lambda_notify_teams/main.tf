

resource "aws_lambda_function" "notify_teams" {
  function_name    = var.lambda_name
  handler         = "lambda_notify_teams.lambda_handler"
  runtime         = "python3.8"
  role            =  var.lambda_role_arn != "" ? var.lambda_role_arn : aws_iam_role.lambda_execution_role.arn
  filename        = "${path.module}/lambda_notify_teams.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_notify_teams.zip")

  environment {
    variables = {
      teams_webhook_url = var.teams_webhook_url
    }
  }
}

## IAM Permission to allow Step Function to invoke Lambda
resource "aws_lambda_permission" "allow_step_function" {
  statement_id  = "AllowStepFunctionInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notify_teams.function_name
  principal     = "states.amazonaws.com"
}


resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-notify-teams-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}
