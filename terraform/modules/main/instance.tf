/*
resource "aws_instance" "bastion" {
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
  ami = "${lookup(var.amis, var.env_region)}"
  instance_type = "t2.small"
  availability_zone = "${var.env_region}a"
  key_name = "batman"
  security_groups = [
    "default",
    "${aws_security_group.bastion.name}",
    "${aws_security_group.api.name}"]
  tags {
    Name = "${var.env_name}-bastion"
    Terraformed = 1
    Environment = "${var.env_name}"
    Disposable = "true"
  }
  lifecycle {
    create_before_destroy = true
  }

  provisioner "file" {
    content = <<EOC
export PGHOST=${aws_db_instance.database.address}
export PGPASSWORD=${aws_db_instance.database.password}
export PGDATABASE=${aws_db_instance.database.name}
export PGPORT=${aws_db_instance.database.port}
export PGUSER=root
export ENV_NAME=${var.env_name}
export API_ROOT=https://api.x5e.${var.env_name}/
export PATH=.:$PATH
EOC
    destination = "/home/ubuntu/vars.sh"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(pathexpand("~/.ssh/batman.pem"))}"
    }
  }

    provisioner "file" {
    source      = "${path.cwd}/../../../docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(pathexpand("~/.ssh/batman.pem"))}"
    }
  }

    provisioner "file" {
    source      = "${path.cwd}/../../../bash/DeployFromQuay.sh"
    destination = "/home/ubuntu/deploy"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(pathexpand("~/.ssh/batman.pem"))}"
    }
  }


  provisioner "remote-exec" {
    script = "${path.cwd}/../../../bash/configure_ubuntu.sh"
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(pathexpand("~/.ssh/batman.pem"))}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/deploy",
      "~/deploy ${var.branch}",
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(pathexpand("~/.ssh/batman.pem"))}"
    }
  }

}
*/