provider "aws" {
  region = "${var.env_region}"
}

data "aws_caller_identity" "whoami" {}
