

data "aws_route53_zone" "env_zone" {
  name = "${var.env_domain}."
}


resource "aws_route53_record" "lb" {
  zone_id = "${data.aws_route53_zone.env_zone.zone_id}"
  name    = "*.internal.${var.env_domain}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.main.dns_name}"]
}

