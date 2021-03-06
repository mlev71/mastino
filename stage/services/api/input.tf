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

data "aws_security_group" "datacite-private" {
  id = "${var.security_group_id}"
}

data "aws_subnet" "datacite-private" {
  id = "${var.subnet_datacite-private_id}"
}

data "aws_subnet" "datacite-alt" {
  id = "${var.subnet_datacite-alt_id}"
}

data "aws_ecs_cluster" "stage" {
  cluster_name = "stage"
}

data "aws_iam_role" "ecs_service" {
  name = "ecs_service"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_lb" "stage" {
  name = "${var.lb_name}"
}

data "aws_lb_listener" "stage" {
  load_balancer_arn = "${data.aws_lb.stage.arn}"
  port = 443
}

/* data "aws_lb_target_group" "profiles-stage" {
  name = "profiles-stage"
} */

data "template_file" "api_task" {
  template = "${file("api.json")}"

  vars {
    solr_url           = "${var.solr_url}"
    volpino_url        = "${var.volpino_url}"
    volpino_token      = "${var.volpino_token}"
    api_url            = "${var.api_url}"
    blog_url           = "${var.blog_url}"
    jwt_public_key     = "${var.jwt_public_key}"
    orcid_update_uuid  = "${var.orcid_update_uuid}"
    orcid_update_url   = "${var.orcid_update_url}"
    orcid_update_token = "${var.orcid_update_token}"
    github_personal_access_token = "${var.github_personal_access_token}"
    github_milestones_url = "${var.github_milestones_url}"
    github_issues_repo_url = "${var.github_issues_repo_url}"
    bugsnag_key        = "${var.bugsnag_key}"
    mailgun_api_key    = "${var.mailgun_api_key}"
    memcache_servers   = "${var.memcache_servers}"
    version            = "${var.spinone_tags["sha"]}"
  }
}
