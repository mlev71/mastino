resource "aws_ecs_service" "data-stage" {
  name = "data-stage"
  cluster = "${data.aws_ecs_cluster.stage.id}"
  launch_type = "FARGATE"
  task_definition = "${aws_ecs_task_definition.data-stage.arn}"
  desired_count = 1

  network_configuration {
    security_groups = ["${data.aws_security_group.datacite-private.id}"]
    subnets         = [
      "${data.aws_subnet.datacite-private.id}",
      "${data.aws_subnet.datacite-alt.id}"
    ]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.data-stage.id}"
    container_name   = "data-stage"
    container_port   = "80"
  }

  depends_on = [
    "data.aws_lb_listener.stage",
  ]
}

resource "aws_cloudwatch_log_group" "data-stage" {
  name = "/ecs/data-stage"
}

resource "aws_ecs_task_definition" "data-stage" {
  family = "data-stage"
  execution_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "512"
  memory = "2048"

  container_definitions =  "${data.template_file.data_task.rendered}"
}

resource "aws_lb_target_group" "data-stage" {
  name     = "data-stage"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  target_type = "ip"

  health_check {
    path = "/heartbeat"
  }
}

resource "aws_lb_listener_rule" "data-stage" {
  listener_arn = "${data.aws_lb_listener.stage.arn}"
  priority     = 60

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.data-stage.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.data-stage.name}"]
  }
}

resource "aws_route53_record" "data-stage" {
    zone_id = "${data.aws_route53_zone.production.zone_id}"
    name = "data.test.datacite.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.stage.dns_name}"]
}

resource "aws_route53_record" "split-data-stage" {
    zone_id = "${data.aws_route53_zone.internal.zone_id}"
    name = "data.test.datacite.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.stage.dns_name}"]
}
