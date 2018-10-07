

resource "random_id" "airflow_password" {
  byte_length = 16
}


resource "postgresql_role" "airflow" {
  name     = "airflow"
  login    = true
  password = "${random_id.db_password.hex}"
  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_ssm_parameter" "airflow" {
  name = "/${var.env_name}/airflow/PGPASSWORD"
  type  = "SecureString"
  value = "${postgresql_role.airflow.password}"
  overwrite = "true"
}