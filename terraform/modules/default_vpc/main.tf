data "aws_caller_identity" "whoami" {}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnet" "a" {
  availability_zone = "${var.env_region}a"
  default_for_az = true
  vpc_id = "${data.aws_vpc.main.id}"
}

data "aws_subnet" "b" {
  availability_zone = "${var.env_region}b"
  vpc_id = "${data.aws_vpc.main.id}"
  default_for_az = true
}