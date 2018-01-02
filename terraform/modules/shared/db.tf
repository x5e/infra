
resource "random_id" "db_password" {
  byte_length = 16
}

resource "aws_db_subnet_group" "main" {
  subnet_ids = ["${module.vpc.subnet_a}", "${module.vpc.subnet_b}"]
}


resource "aws_db_instance" "database" {
  count = 1
  instance_class = "db.t2.small" # encryption not supported on t2.micro
  identifier = "${var.env_name}"
  name = "${var.env_name}"
  allocated_storage    = 5
  storage_type         = "gp2"
  apply_immediately    = true
  storage_encrypted = true
  backup_retention_period = 3
  publicly_accessible = true
  username = "root"
  password = "${random_id.db_password.hex}"
  monitoring_interval = 0
  port = 5432
  engine = "postgres"
  availability_zone = "${var.env_region}a"
  db_subnet_group_name = "${aws_db_subnet_group.main.name}"
  vpc_security_group_ids = ["${aws_default_security_group.default.id}"]
  skip_final_snapshot = "${var.disposable}"
  tags {
    Terraformed = "1"
    Environment = "${var.env_name}"
    Disposable = "${var.disposable}"
  }
}

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


resource "aws_route53_record" "db" {
  name = "db.${var.env_domain}"
  type = "CNAME"
  zone_id = "${data.aws_route53_zone.env_zone.zone_id}"
  ttl     = "60"
  records = ["${aws_db_instance.database.address}"]
}
