


data external "ipify" {
  program = ["curl", "https://api.ipify.org?format=json"]
}


resource "aws_default_security_group" "default" {
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    description = "within security group"
  }


  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = "${var.trusted}"
    description = "trusted"
  }


  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${data.external.ipify.result.ip}/32"]
    description = "terraforming computer"
  }

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    protocol  = "tcp"
    from_port = 3309
    to_port   = 3309
    cidr_blocks = ["0.0.0.0/0"]
    description = "tcp-ping utility"
  }

  ingress {
    protocol  = "tcp"
    from_port = 1234
    to_port   = 1234
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow latency test to skip load balancer"
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow https from outside"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
