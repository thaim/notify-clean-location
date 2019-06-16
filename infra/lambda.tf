data "archive_file" "dummy" {
  type        = "zip"
  output_path = "${path.module}/lambda_function_dummy.zip"

  source {
    content  = "dummy"
    filename = "dummy.txt"
  }
}

resource "aws_iam_role" "lambda-ncl" {
  name = "lambda-ncl"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "notify-clean-location" {
  filename = "${data.archive_file.dummy.output_path}"
  function_name = "notify-clean-location"
  role = "${aws_iam_role.lambda-ncl.arn}"
  handler = "notify.lambda_handler"
  runtime = "python3.6"

  memory_size = 128
  timeout = 30

  environment {
    variables = {
      slackChannel = "${var.slack_channel}"
      slackPostURL = "${var.slack_post_url}"
    }
  }
}
