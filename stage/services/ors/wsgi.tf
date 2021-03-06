# WSGI Service
resource "aws_ecs_service" "wsgi-stage" {
   name = "wsgi-stage"
   cluster = "${data.aws_ecs_cluster.stage.id}"
   launch_type = "FARGATE"
   task_definition = "${aws_ecs_task_definition.wsgi-stage.arn}"
   desired_count = 1

  load_balancer {
    target_group_arn = "${aws_lb_target_group.wsgi-stage.id}"
    container_name   = "wsgi-stage"
    container_port   = "3031"
  }

   network_configuration {
      security_groups = ["${data.aws_security_group.datacite-private.id}"]
      subnets         = [
         "${data.aws_subnet.datacite-private.id}",
         "${data.aws_subnet.datacite-alt.id}"
      ]
  }

  depends_on = [
    "data.aws_lb_listener.stage",
  ]

  // service_registries {
  //   registry_arn = "${aws_service_discovery_service.wsgi-stage.arn}"
  // }
}

resource "aws_cloudwatch_log_group" "wsgi-stage" {
  name = "/ecs/wsgi-stage"
}

resource "aws_ecs_task_definition" "wsgi-stage" {
   family = "wsgi-stage"
   execution_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}"
   requires_compatibilities = ["FARGATE"]
   network_mode = "awsvpc"
   cpu = "512"
   memory = "2048"

   container_definitions = "${data.template_file.wsgi_task.rendered}"
}

resource "aws_lb_target_group" "wsgi-stage" {
   name     = "wsgi-stage"
   port     = 3031
   protocol = "HTTP"
   vpc_id   = "${var.vpc_id}"
   target_type = "ip"

   health_check {
      path = "/"
   }
}

resource "aws_lb_listener_rule" "wsgi-stage" {
   listener_arn = "${data.aws_lb_listener.stage.arn}"
   priority     = 124

   action {
      type             = "forward"
      target_group_arn = "${aws_lb_target_group.wsgi-stage.arn}"
   }

   condition {
      field  = "host-header"
      values = ["ors.test.datacite.org"]
   }
}

resource "aws_route53_record" "ors-stage" {
   zone_id = "${data.aws_route53_zone.production.zone_id}"
   name = "ors.test.datacite.org"
   type = "CNAME"
   ttl = "${var.ttl}"
   records = ["${data.aws_lb.stage.dns_name}"]
}

resource "aws_route53_record" "split-ors-stage" {
   zone_id = "${data.aws_route53_zone.internal.zone_id}"
   name = "ors.test.datacite.org"
   type = "CNAME"
   ttl = "${var.ttl}"
   records = ["${data.aws_lb.stage.dns_name}"]
}

// resource "aws_service_discovery_service" "wsgi-stage" {
//   name = "wsgi"

//   health_check_custom_config {
//     failure_threshold = 1
//   }

//   dns_config {
//     namespace_id = "${aws_service_discovery_private_dns_namespace.internal-stage.id}"
//     dns_records {
//       ttl = 300
//       type = "A"
//     }
//   }
// }

// resource "aws_route53_record" "wsgi-stage" {
//    zone_id = "${data.aws_route53_zone.internal.zone_id}"
//    name = "wsgi.test.datacite.org"
//    type = "A"

//    alias {
//      name = "${aws_service_discovery_service.wsgi-stage.name}.${aws_service_discovery_private_dns_namespace.internal-stage.name}"
//      zone_id = "${aws_service_discovery_private_dns_namespace.internal-stage.hosted_zone}"
//      evaluate_target_health = true
//    }
// }