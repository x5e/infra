data "aws_ssm_parameter" "cluster" {
  name = "/${var.env_name}/shared/CLUSTER"
}

data "aws_ssm_parameter" "listener" {
  name = "/${var.env_name}/shared/LISTENER"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.env_name}/shared/VPC_ID"
}


