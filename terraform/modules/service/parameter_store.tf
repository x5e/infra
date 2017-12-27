data "aws_ssm_parameter" "cluster" {
  name = "/${var.env_name}/shared/CLUSTER"
}

data "aws_ssm_parameter" "listener" {
  name = "/${var.env_name}/shared/LISTENER"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.env_name}/shared/VPC_ID"
}

data "aws_ssm_parameter" "pghost" {
  name  = "/${var.env_name}/shared/PGHOST"
}

data "aws_ssm_parameter" "pgdatabase" {
  name  = "/${var.env_name}/shared/PGDATABASE"
}

data "aws_ssm_parameter" "pguser" {
  name  = "/${var.env_name}/shared/PGUSER"
}

data "aws_ssm_parameter" "pgpassword" {
  name  = "/${var.env_name}/shared/PGPASSWORD"
}