
resource "random_id" "db_password" {
  byte_length = 16
}

resource "aws_db_subnet_group" "main" {
  subnet_ids = ["${aws_subnet.a.id}", "${aws_subnet.b.id}"]
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
  #multi_az = true
  lifecycle {
    // prevent_destroy can't be interpolated
  }
  skip_final_snapshot = "${var.disposable}"
  tags {
    Terraformed = "1"
    Environment = "${var.env_name}"
    Disposable = "${var.disposable}"
  }
}

output "db_password" {
  value = "${random_id.db_password.hex}"
}