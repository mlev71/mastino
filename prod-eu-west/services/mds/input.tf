provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_route53_zone" "production" {
  name         = "datacite.org"
}

data "aws_route53_zone" "internal" {
  name         = "datacite.org"
  private_zone = true
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

data "aws_lb" "default" {
  name = "${var.lb_name}"
}

data "aws_lb" "alternate" {
  name = "lb-alternate"
}

data "aws_lb_listener" "default" {
  load_balancer_arn = "${data.aws_lb.default.arn}"
  port = 443
}

data "aws_lb_listener" "alternate" {
  load_balancer_arn = "${data.aws_lb.alternate.arn}"
  port = 443
}

data "aws_ecs_cluster" "default" {
  cluster_name = "default"
}

data "aws_iam_role" "ecs_service" {
  name = "ecs_service"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "template_file" "mds_task" {
  template = "${file("mds.json")}"

  vars {
    bugsnag_key        = "${var.bugsnag_key}"
    memcache_servers   = "${var.memcache_servers}"
    version            = "${var.poodle_tags["version"]}"
  }
}


data "aws_instance" "main" {
  instance_id = "${var.main_id}"
}