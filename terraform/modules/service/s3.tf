
resource "aws_s3_bucket" "service" {
  count = "${var.need_s3_bucket}"
  bucket = "${data.aws_caller_identity.whoami.account_id}-${var.env_name}-${var.service_name}"
  tags {
    Environment = "${var.env_name}"
    Service = "${var.service_name}"
  }
}


resource "aws_ssm_parameter" "bucket" {
  count = "${var.need_s3_bucket}"
  name = "/${var.env_name}/${var.service_name}/BUCKET"
  type = "SecureString"
  value = "${postgresql_role.service.name}"
  overwrite = "true"
}