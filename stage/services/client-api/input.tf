provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_route53_zone" "production" {
  name = "datacite.org"
}

data "aws_route53_zone" "internal" {
  name = "datacite.org"
  private_zone = true
}

data "aws_ecs_cluster" "stage" {
  cluster_name = "stage"
}

data "aws_iam_role" "ecs_service" {
  name = "ecs_service"
}

data "aws_lb" "stage" {
  name = "${var.lb_name}"
}

data "aws_lb_listener" "stage" {
  load_balancer_arn = "${data.aws_lb.stage.arn}"
  port = 443
}

data "template_file" "client-api_task" {
  template = "${file("client-api.json")}"

  vars {
    re3data_url        = "${var.re3data_url}"
    bracco_url         = "${var.bracco_url}"
    levriero_url       = "${var.levriero_url}"
    jwt_public_key     = "${var.jwt_public_key}"
    jwt_private_key    = "${var.jwt_private_key}"
    secret_key_base    = "${var.secret_key_base}"
    session_encrypted_cookie_salt = "${var.session_encrypted_cookie_salt}"
    mysql_user         = "${var.mysql_user}"
    mysql_password     = "${var.mysql_password}"
    mysql_database     = "${var.mysql_database}"
    mysql_host         = "${var.mysql_host}"
    access_key         = "${var.access_key}"
    secret_key         = "${var.secret_key}"
    region             = "${var.region}"
    bugsnag_key        = "${var.bugsnag_key}"
    mailgun_api_key    = "${var.mailgun_api_key}"
    memcache_servers   = "${var.memcache_servers}"
    librato_email      = "${var.librato_email}"
    librato_token      = "${var.librato_token}"
    librato_suites     = "${var.librato_suites}"
    version            = "${var.lupo_tags["sha"]}"
  }
}
