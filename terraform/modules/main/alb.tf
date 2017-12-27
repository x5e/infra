
resource "aws_lb" "main" {
  name = "${var.env_name}"
  internal = false
  security_groups = ["${aws_default_security_group.default.id}"]
  load_balancer_type = "application"
  subnets = ["${aws_subnet.a.id}", "${aws_subnet.b.id}"]
  tags {
    Environment = "${var.env_name}"
    Terraformed = "1"
  }
}


resource "aws_lb_target_group" "default" {
  name     = "${var.env_name}"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}


resource "aws_lb_listener" "main" {
  load_balancer_arn = "${aws_lb.main.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.cert_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.default.arn}"
    type             = "forward"
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.asg.id}"
  alb_target_group_arn   = "${aws_lb_target_group.default.arn}"
}

