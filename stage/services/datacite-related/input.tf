provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "template_file" "datacite_related_test_task" {
  template = "${file("datacite-related.json")}"

  vars {
    access_token = "${var.access_token}"
    source_token = "${var.source_token}"
    push_url     = "${var.push_url}"
  }
}
data "aws_iam_role" "lambda" {
  name = "lambda"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_security_group" "datacite-private" {
  id = "${var.security_group_id}"
}

data "aws_subnet" "datacite-private" {
  id = "${var.subnet_datacite-private_id}"
}

data "aws_subnet" "datacite-alt" {
  id = "${var.subnet_datacite-alt_id}"
}
