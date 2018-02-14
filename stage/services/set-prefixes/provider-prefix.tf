resource "aws_cloudwatch_event_rule" "set-provider-created-test" {
  name = "set-provider-created-test"
  description = "Run set-provider-created API call via cron"
  schedule_expression = "cron(20 1 * * ? *)"
}

resource "aws_cloudwatch_event_target" "set-provider-created-test" {
  target_id = "set-provider-created-test"
  rule = "${aws_cloudwatch_event_rule.set-provider-created-test.name}"
  arn = "${aws_lambda_function.set-provider-created-test.arn}"
}

resource "aws_lambda_function" "set-provider-created-test" {
  filename = "set_prefixes_runner.js.zip"
  function_name = "set-provider-created-test"
  role = "${data.aws_iam_role.lambda.arn}"
  handler = "set_prefixes_runner.handler"
  runtime = "nodejs6.10"
  source_code_hash = "${base64sha256(file("set_prefixes_runner.js.zip"))}"
  timeout = "270"

  vpc_config {
    subnet_ids = ["${data.aws_subnet.datacite-private.id}", "${data.aws_subnet.datacite-alt.id}"]
    security_group_ids = ["${data.aws_security_group.datacite-private.id}"]
  }
  environment {
    variables = {
      host     = "${var.host}"
      path     = "${var.provider_created_path}"
      username = "${var.username}"
      password = "${var.password}"
    }
  }
}

resource "aws_lambda_permission" "set-provider-created-test" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.set-provider-created-test.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.set-provider-created-test.arn}"
}
