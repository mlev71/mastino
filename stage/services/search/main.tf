resource "aws_s3_bucket" "search-stage" {
    bucket = "search.test.datacite.org"
    acl = "public-read"
    policy = "${data.template_file.search-stage.rendered}"
    website {
        index_document = "index.html"
    }
    tags {
        Name = "Search Stage"
    }
}

resource "aws_ecs_service" "search-stage" {
  name = "search-stage"
  cluster = "${data.aws_ecs_cluster.stage.id}"
  task_definition = "${aws_ecs_task_definition.search-stage.arn}"
  desired_count = 1
  iam_role        = "${data.aws_iam_role.ecs_service.arn}"

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.search-stage.id}"
    container_name   = "search-stage"
    container_port   = "80"
  }
}

resource "aws_lb_target_group" "search-stage" {
  name     = "search-stage"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    type   = "lb_cookie"
  }
}

resource "aws_ecs_task_definition" "search-stage" {
  family = "search-stage"
  container_definitions =  "${data.template_file.search_stage_task.rendered}"
}

resource "aws_lb_listener_rule" "solr-stage-api" {
  listener_arn = "${data.aws_lb_listener.stage.arn}"
  priority     = 80

  action {
    type             = "forward"
    target_group_arn = "${data.aws_lb_target_group.solr-stage.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.search-stage.name}"]
  }
  condition {
    field  = "path-pattern"
    values = ["/api*"]
  }
}

resource "aws_lb_listener_rule" "solr-stage-list" {
  listener_arn = "${data.aws_lb_listener.stage.arn}"
  priority     = 81

  action {
    type             = "forward"
    target_group_arn = "${data.aws_lb_target_group.solr-stage.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.search-stage.name}"]
  }
  condition {
    field  = "path-pattern"
    values = ["/list*"]
  }
}

resource "aws_lb_listener_rule" "solr-stage-ui" {
  listener_arn = "${data.aws_lb_listener.stage.arn}"
  priority     = 82

  action {
    type             = "forward"
    target_group_arn = "${data.aws_lb_target_group.solr-stage.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.search-stage.name}"]
  }
  condition {
    field  = "path-pattern"
    values = ["/ui*"]
  }
}

resource "aws_lb_listener_rule" "solr-stage-resources" {
  listener_arn = "${data.aws_lb_listener.stage.arn}"
  priority     = 83

  action {
    type             = "forward"
    target_group_arn = "${data.aws_lb_target_group.solr-stage.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.search-stage.name}"]
  }
  condition {
    field  = "path-pattern"
    values = ["/resources*"]
  }
}

resource "aws_lb_listener_rule" "search-stage" {
  listener_arn = "${data.aws_lb_listener.stage.arn}"
  priority     = 89

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.search-stage.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.search-stage.name}"]
  }
}

resource "aws_route53_record" "search-stage" {
   zone_id = "${data.aws_route53_zone.production.zone_id}"
   name = "search.test.datacite.org"
   type = "CNAME"
   ttl = "${var.ttl}"
   records = ["${data.aws_lb.stage.dns_name}"]
}

resource "aws_route53_record" "split-search-stage" {
   zone_id = "${data.aws_route53_zone.internal.zone_id}"
   name = "search.test.datacite.org"
   type = "CNAME"
   ttl = "${var.ttl}"
   records = ["${data.aws_lb.stage.dns_name}"]
}
