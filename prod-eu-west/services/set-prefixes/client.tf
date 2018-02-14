resource "aws_cloudwatch_event_rule" "set-client-test-prefix" {
  name = "set-client-test-prefix"
  description = "Run set-client-test-prefix API call via cron"
  schedule_expression = "cron(30 2 * * ? *)"
}

resource "aws_cloudwatch_event_target" "set-client-test-prefix" {
  target_id = "set-client-test-prefix"
  rule = "${aws_cloudwatch_event_rule.set-client-test-prefix.name}"
  arn = "${aws_lambda_function.set-client-test-prefix.arn}"
}

resource "aws_lambda_function" "set-client-test-prefix" {
  filename = "set_prefixes_runner.js.zip"
  function_name = "set-client-test-prefix"
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
      path     = "${var.client_test_prefix_path}"
      username = "${var.username}"
      password = "${var.password}"
    }
  }
}

resource "aws_lambda_permission" "set-client-test-prefix" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.set-client-test-prefix.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.set-client-test-prefix.arn}"
}
