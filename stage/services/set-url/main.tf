resource "aws_cloudwatch_event_rule" "set-url-test" {
  name = "set-url-test"
  description = "Run set-url API call via cron"
  schedule_expression = "cron(00 1,5,9,13,17,21 * * ? *)"
}

resource "aws_cloudwatch_event_target" "set-url-test" {
  target_id = "set-url-test"
  rule = "${aws_cloudwatch_event_rule.set-url-test.name}"
  arn = "${aws_lambda_function.set-url-test.arn}"
}

resource "aws_lambda_function" "set-url-test" {
  filename = "set_state_runner.js.zip"
  function_name = "set-url-test"
  role = "${data.aws_iam_role.lambda.arn}"
  handler = "set_state_runner.handler"
  runtime = "nodejs6.10"
  source_code_hash = "${base64sha256(file("set_state_runner.js.zip"))}"
  timeout = "270"

  vpc_config {
    subnet_ids = ["${data.aws_subnet.datacite-private.id}", "${data.aws_subnet.datacite-alt.id}"]
    security_group_ids = ["${data.aws_security_group.datacite-private.id}"]
  }
  environment {
    variables = {
      host     = "${var.host}"
      path     = "${var.url_path}"
      username = "${var.username}"
      password = "${var.password}"
    }
  }
}

resource "aws_lambda_permission" "set-url-test" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.set-url-test.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.set-url-test.arn}"
}
