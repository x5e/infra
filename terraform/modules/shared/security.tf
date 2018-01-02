


data external "ipify" {
  program = ["curl", "https://api.ipify.org?format=json"]
}


resource "aws_default_security_group" "default" {
  vpc_id = "${module.vpc.vpc_id}"

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["172.26.0.0/16", "69.162.169.108/32", "${data.external.ipify.result.ip}/32"]
  }


  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow https from outside"
  }


}
