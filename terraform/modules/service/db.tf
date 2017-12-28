provider "postgresql" {
  host            = "${data.aws_ssm_parameter.pghost.value}"
  database        = "${data.aws_ssm_parameter.pgdatabase.value}"
  username        = "${data.aws_ssm_parameter.pguser.value}"
  password        = "${data.aws_ssm_parameter.pgpassword.value}"
  sslmode         = "require"
  connect_timeout = 1
}


resource "random_id" "db_password" {
  byte_length = 16
}


resource "postgresql_role" "service" {
  name     = "${var.service_name}"
  login    = true
  password = "${random_id.db_password.hex}"
}


resource "postgresql_database" "service" {
  name              = "${var.service_name}"
  owner             = "${postgresql_role.service.name}"
}

resource "aws_ssm_parameter" "pguser" {
  name = "/${var.env_name}/${var.service_name}/PGUSER"
  type = "SecureString"
  value = "${postgresql_role.service.name}"
}

resource "aws_ssm_parameter" "pgpassword" {
  name = "/${var.env_name}/${var.service_name}/PGPASSWORD"
  type  = "SecureString"
  value = "${postgresql_role.service.password}"
}

resource "aws_ssm_parameter" "pghost" {
  name = "/${var.env_name}/${var.service_name}/PGHOST"
  type = "SecureString"
  value = "${data.aws_ssm_parameter.pghost.value}"
}

resource "aws_ssm_parameter" "pgdatabase" {
  name = "/${var.env_name}/${var.service_name}/PGDATABASE"
  type = "SecureString"
  value = "${postgresql_database.service.name}"
}