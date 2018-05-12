resource "aws_lb_target_group" "mds" {
  name     = "mds"
  vpc_id   = "${var.vpc_id}"
  port     = 80
  protocol = "HTTP"
}

resource "aws_lb_target_group_attachment" "mds" {
  target_group_arn = "${aws_lb_target_group.mds.arn}"
  target_id        = "${data.aws_instance.main.id}"
}

resource "aws_lb_listener_rule" "mds" {
  listener_arn = "${data.aws_lb_listener.default.arn}"
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.mds.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.mds.name}"]
  }
}

resource "aws_route53_record" "mds" {
   zone_id = "${data.aws_route53_zone.production.zone_id}"
   name = "mds.datacite.org"
   type = "CNAME"
   ttl = "${var.ttl}"
   records = ["${data.aws_lb.default.dns_name}"]
}

resource "aws_route53_record" "internal-mds-split" {
   zone_id = "${data.aws_route53_zone.internal.zone_id}"
   name = "mds.datacite.org"
   type = "CNAME"
   ttl = "${var.ttl}"
   records = ["${data.aws_lb.default.dns_name}"]
}

// locals {
//   target_group_mds_id = "${element(split("/", aws_lb_target_group.mds.arn_suffix), 2)}"
//   source_mds = "app-lb-${local.lb_listener_default_id}.targetgroup-mds-${local.target_group_mds_id}"
// }

// resource "librato_space_chart" "alb-mds-request-time" {
//   name = "Request Time MDS"
//   label = "Milliseconds"
//   space_id = "${librato_space.lb.id}"
//   type = "line"

//   stream {
//     metric = "AWS.ApplicationELB.TargetResponseTime"
//     source = "${local.source_mds}"
//     transform_function = "x*1000"
//   }
// }

// resource "librato_space_chart" "alb-mds-request-types" {
//   name = "Request Types MDS"
//   space_id = "${librato_space.lb.id}"
//   type = "stacked"

//   stream {
//     metric = "AWS.ApplicationELB.HTTPCode_Target_2XX_Count"
//     source = "${local.source_mds}"
//     color = "#61bb4b"
//   }
//   stream {
//     metric = "AWS.ApplicationELB.HTTPCode_Target_3XX_Count"
//     source = "${local.source_mds}"
//     color = "#235a94"
//   }
//   stream {
//     metric = "AWS.ApplicationELB.HTTPCode_Target_4XX_Count"
//     source = "${local.source_mds}"
//     color = "#e68417"
//   }
//   stream {
//     metric = "AWS.ApplicationELB.HTTPCode_Target_5XX_Count"
//     source = "${local.source_mds}"
//     color = "#e63c2f"
//   }
// }
