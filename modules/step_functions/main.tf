resource "aws_sfn_state_machine" "event_workflow" {
  name       = "event-processing-workflow"
  role_arn   = var.role_arn
  definition = jsonencode({
    Comment = "A Step Function to process event messages"
    StartAt = "CheckEventType"
    States = {
      CheckEventType = {
        Type     = "Choice",
        Choices = [
          {
            Variable    = "$.attributes.eventtype",
            StringEquals = "trigger",
            Next       = "CheckProductName"
          }
        ],
        Default = "FailState"
      },
      CheckProductName = {
        Type     = "Choice",
        Choices = [
          {
            Variable    = "$.attributes.productname",
            StringEquals = "SBS",
            Next       = "InvokeLambda"
          }
        ],
        Default = "FailState"
      },
      InvokeLambda = {
        Type     = "Task",
        Resource = var.lambda_notify_teams_arn,
        End      = true
      },
      FailState = {
        Type     = "Fail",
        Cause    = "Event does not meet criteria",
        Error    = "InvalidEvent"
      }
    }
  })
}
