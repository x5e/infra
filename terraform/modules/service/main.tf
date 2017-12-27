resource "aws_alb_target_group" "service" {
  name = "${var.service_name}-${var.env_name}"
  port = "${var.service_port}"
  protocol = "HTTP"
  vpc_id = "${data.aws_ssm_parameter.vpc_id.value}"
}


resource "aws_lb_listener_rule" "static" {
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

resource "aws_cloudwatch_log_group" "service" {
  name = "/ecs/${var.service_name}"
}

data "aws_caller_identity" "whoami" {}

data "template_file" "containers" {
  template = "${file("${path.module}/containers.tmpl")}"
  vars {
    LOGS = "${aws_cloudwatch_log_group.service.name}"
    CPU = "${var.cpu}"
    MEMORY = "${var.memory}"
    NAME = "${var.service_name}"
    PORT = "${var.service_port}"
    REGION = "${var.region}"
    ACCT = "${data.aws_caller_identity.whoami.account_id}"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                = "${var.service_name}-${var.env_name}"
  container_definitions = ""
  cpu = "${var.cpu}"
  memory = "${var.memory}"
  network_mode = "${var.network_mode}"
}

resource "aws_ecs_service" "main" {
  name = "${var.service_name}-${var.env_name}"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  cluster = "${data.aws_ssm_parameter.cluster.value}"
  desired_count = 1
  load_balancer {
    container_name = "${var.service_name}"
    container_port = "${var.service_port}"
    target_group_arn = "${aws_alb_target_group.service.arn}"
  }
}