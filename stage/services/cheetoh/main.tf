resource "aws_ecs_service" "cheetoh-stage" {
  name = "cheetoh-stage"
  cluster = "${data.aws_ecs_cluster.stage.id}"
  launch_type = "FARGATE"
  task_definition = "${aws_ecs_task_definition.cheetoh-stage.arn}"
  desired_count = 1

  network_configuration {
    security_groups = ["${data.aws_security_group.datacite-private.id}"]
    subnets         = [
      "${data.aws_subnet.datacite-private.id}",
      "${data.aws_subnet.datacite-alt.id}"
    ]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.cheetoh-stage.id}"
    container_name   = "cheetoh-stage"
    container_port   = "80"
  }

  depends_on = [
    "data.aws_lb_listener.stage",
  ]
}

resource "aws_cloudwatch_log_group" "cheetoh-stage" {
  name = "/ecs/cheetoh-stage"
}

resource "aws_ecs_task_definition" "cheetoh-stage" {
  family = "cheetoh-stage"
  execution_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "512"
  memory = "1024"

  container_definitions =  "${data.template_file.cheetoh_task.rendered}"
}

resource "aws_lb_target_group" "cheetoh-stage" {
  name     = "cheetoh-stage"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  target_type = "ip"

  health_check {
    path = "/heartbeat"
  }
}

resource "aws_lb_listener_rule" "cheetoh-stage" {
  listener_arn = "${data.aws_lb_listener.stage.arn}"
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.cheetoh-stage.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.cheetoh-stage.name}"]
  }
}

resource "aws_route53_record" "cheetoh-stage" {
    zone_id = "${data.aws_route53_zone.production.zone_id}"
    name = "ez.test.datacite.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.stage.dns_name}"]
}

resource "aws_route53_record" "split-cheetoh-stage" {
    zone_id = "${data.aws_route53_zone.internal.zone_id}"
    name = "ez.test.datacite.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.stage.dns_name}"]
}
