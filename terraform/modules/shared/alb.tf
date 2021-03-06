
resource "aws_lb" "main" {
  name = "${var.env_name}"
  internal = true
  security_groups = ["${aws_default_security_group.default.id}"]
  load_balancer_type = "application"
  subnets = ["${module.vpc.subnet_a}", "${module.vpc.subnet_b}"]
  tags {
    Environment = "${var.env_name}"
    Terraformed = "1"
  }
}


resource "aws_ssm_parameter" "balancer" {
  name = "/${var.env_name}/shared/BALANCER"
  type = "SecureString"
  value = "${aws_lb.main.arn}"
  overwrite = "true"
}



resource "aws_lb_target_group" "default" {
  name     = "${var.env_name}"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
}


resource "aws_lb_listener" "main" {
  load_balancer_arn = "${aws_lb.main.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.default.arn}"
    type             = "forward"
  }
}


resource "aws_ssm_parameter" "listener" {
  name = "/${var.env_name}/shared/LISTENER"
  type = "SecureString"
  value = "${aws_lb_listener.main.arn}"
  overwrite = "true"
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.asg.id}"
  alb_target_group_arn   = "${aws_lb_target_group.default.arn}"
}

