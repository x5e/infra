
provider "aws" {
  region = "${var.region}"
}


resource "aws_alb_target_group" "service" {
  count = "${var.has_service}"
  name = "${var.service_name}-${var.env_name}"
  port = "${var.service_port}"
  protocol = "HTTP"
  vpc_id = "${data.aws_ssm_parameter.vpc_id.value}"
}


resource "aws_lb_listener_rule" "static" {
  count = "${var.has_service}"
  listener_arn = "${data.aws_ssm_parameter.listener.value}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.service.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/${var.service_name}/*"]
  }
}

resource "aws_lb_listener" "service" {
  count = "${var.has_service}"
  "default_action" {
    target_group_arn = "${aws_alb_target_group.service.arn}"
    type = "forward"
  }
  load_balancer_arn = "${data.aws_ssm_parameter.balancer.value}"
  port = "${var.service_port}"
}

resource "aws_cloudwatch_log_group" "service" {
  count = "${var.has_service}"
  name = "/ecs/${var.service_name}"
}

data "aws_caller_identity" "whoami" {}

data "template_file" "containers" {
  count = "${var.has_service}"
  template = "${file("${path.module}/containers.tmpl")}"
  vars {
    LOGS = "${aws_cloudwatch_log_group.service.name}"
    CPU = "${var.cpu}"
    SOFT = "${var.soft}"
    HARD = "${var.hard}"
    NAME = "${var.service_name}"
    PORT = "${var.service_port}"
    REGION = "${var.region}"
    ACCT = "${data.aws_caller_identity.whoami.account_id}"
    PGHOST = "${aws_ssm_parameter.pghost.value}"
    PGPASSWORD = "${aws_ssm_parameter.pgpassword.value}"
    PGDATABASE = "${aws_ssm_parameter.pgdatabase.value}"
    PGUSER = "${aws_ssm_parameter.pguser.value}"
  }
}


resource "aws_ecs_task_definition" "main" {
  count = "${var.has_service}"
  family                = "${var.service_name}-${var.env_name}"
  container_definitions = "${data.template_file.containers.rendered}"
  network_mode = "${var.network_mode}"
}


resource "aws_ecs_service" "main" {
  count = "${var.has_service}"
  name = "${var.service_name}-${var.env_name}"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  cluster = "${data.aws_ssm_parameter.cluster.value}"
  desired_count = "${var.service_count}"
  load_balancer {
    container_name = "${var.service_name}"
    container_port = "${var.service_port}"
    target_group_arn = "${aws_alb_target_group.service.arn}"
  }
}
