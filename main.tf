module "sns" {
  source         = "./modules/sns"
  sns_topic_name = "event-topic"
  sqs_queue_arn  = module.sqs.sqs_queue_arn

}

module "sqs" {
  source         = "./modules/sqs"
  sqs_queue_name = "event-queue1"
  sns_topic_arn  = module.sns.sns_topic_arn
}

module "lambda" {

    source = "./modules/lambda"
    sqs_queue_url = module.sqs.sqs_queue_url
    sqs_queue_arn = module.sqs.sqs_queue_arn


}

module "step_functions_role" {
  source = "./modules/step_functions_role"
}

module "step_functions" {
  source     = "./modules/step_functions"
  role_arn   = module.step_functions_role.step_functions_role_arn  
  lambda_notify_teams_arn = module.lambda_notify_teams.lambda_function_arn
  lambda_arn = module.lambda.lambda_function_arn
}



module "lambda_notify_teams" {
  source        = "./modules/lambda_notify_teams"
  lambda_name   = "notify-teams"
  # lambda_role_arn = aws_iam_role.lambda_execution_role.arn
  teams_webhook_url = "https://siemens.webhook.office.com/webhookb2/7577326b-c94b-4aa2-a429-b1e35c530a49@38ae3bcd-9579-4fd4-adda-b42e1495d55a/IncomingWebhook/78404c16d5ad48afbf7c21bfef8ec78e/9e6a8079-2286-4b7a-b91b-c7a4e681ff36/V2ptdTv6NczqFIakZpOW8dsF0QNf88XTeQMX_LnO9ZN-o1"

}

