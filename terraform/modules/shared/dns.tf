

data "aws_route53_zone" "env_zone" {
  name = "${var.env_domain}."
}


resource "aws_route53_record" "api" {
  zone_id = "${data.aws_route53_zone.env_zone.zone_id}"
  name    = "api.${var.env_domain}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.main.dns_name}"]
}


resource "aws_route53_record" "region" {
  zone_id = "${data.aws_route53_zone.env_zone.zone_id}"
  name    = "${var.env_region}.${var.env_domain}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.main.dns_name}"]
}



