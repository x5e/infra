
provider "aws" {
  region = "${var.env_region}"
  allowed_account_ids = ["${var.aws_account_id}"]
}
