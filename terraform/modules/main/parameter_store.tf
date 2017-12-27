
resource "aws_ssm_parameter" "pghost" {
  name  = "/${var.env_name}/shared/PGHOST"
  type  = "SecureString"
  value = "${aws_db_instance.database.address}"
  overwrite = "true"
}

resource "aws_ssm_parameter" "pgdatabase" {
  name  = "/${var.env_name}/shared/PGDATABASE"
  type  = "SecureString"
  value = "${aws_db_instance.database.name}"
  overwrite = "true"
}

resource "aws_ssm_parameter" "pguser" {
  name  = "/${var.env_name}/shared/PGUSER"
  type  = "SecureString"
  value = "${aws_db_instance.database.username}"
  overwrite = "true"
}

resource "aws_ssm_parameter" "pgpassword" {
  name  = "/${var.env_name}/shared/PGPASSWORD"
  type  = "SecureString"
  value = "${aws_db_instance.database.password}"
  overwrite = "true"
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.env_name}/shared/VPC_ID"
  type  = "SecureString"
  value = "${aws_vpc.main.id}"
  overwrite = "true"
}

resource "aws_ssm_parameter" "cluster" {
  name  = "/${var.env_name}/shared/CLUSTER"
  type  = "SecureString"
  value = "${aws_ecs_cluster.main.name}"
  overwrite = "true"
}

resource "aws_ssm_parameter" "listener" {
  name = "/${var.env_name}/shared/LISTENER"
  type = "SecureString"
  value = "${aws_lb_listener.main.arn}"
  overwrite = "true"
}