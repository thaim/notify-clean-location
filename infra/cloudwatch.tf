resource "aws_cloudwatch_event_rule" "every_saturday_morning" {
  name                = "every_saturday_morning"
  description         = "毎週土曜の朝に実行"
  schedule_expression = "cron(0 22 ? * FRI *)"
}

resource "aws_cloudwatch_event_target" "trigger_slack_notification" {
  target_id = "invoke_lambda_function"
  rule      = "${aws_cloudwatch_event_rule.every_saturday_morning.name}"
  arn       = "${aws_lambda_function.notify-clean-location.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.notify-clean-location.function_name}"
  principal     = "events.amazonaws.com"
}
