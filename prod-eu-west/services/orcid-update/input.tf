provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "template_file" "orcid_update_task" {
  template = "${file("orcid-update.json")}"

  vars {
    access_token = "${var.access_token}"
    push_url     = "${var.push_url}"
    webhook_url  = "${var.webhook_url}"
    version      = "${var.toccatore_tags["version"]}"
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
