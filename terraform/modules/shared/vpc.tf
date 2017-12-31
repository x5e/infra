
module "vpc" {
  source = "../default_vpc"
  env_region = "${var.env_region}"
}


resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.env_name}/shared/VPC_ID"
  type  = "SecureString"
  value = "${module.vpc.vpc_id}"
  overwrite = "true"
}