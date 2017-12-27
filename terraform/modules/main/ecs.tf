
resource "aws_ecs_cluster" "main" {
  name = "${var.env_name}-main"
}

resource "aws_key_pair" "pair" {
  key_name = "${replace(file(pathexpand("~/.ssh/id_rsa.pub")),"/(.*) (.*) (.*)\\n/", "$3")}"
  public_key = "${file(pathexpand("~/.ssh/id_rsa.pub"))}"
  lifecycle {
    ignore_changes = ["key_name", "public_key"]
  }
}


variable "ecs_amis" {
  // Amazon ECS-Optimized AMIs, Current as of 2017.09
  // http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  type = "map"
  default = {
    us-east-1 = "ami-fad25980"
    us-east-2 = "ami-58f5db3d"
    us-west-1 = "ami-62e0d802"
    us-west-2 = "ami-7114c909"
  }
}

resource "aws_launch_configuration" "lc" {
  name_prefix   = "${var.env_name}-"
  image_id = "${lookup(var.ecs_amis, var.env_region)}"
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
  instance_type = "t2.micro"
  spot_price = "0.02"
  associate_public_ip_address = "true"
  security_groups = ["${aws_default_security_group.default.id}"]
  key_name = "${aws_key_pair.pair.key_name}"
  lifecycle {
    create_before_destroy = true
    ignore_changes = ["key_name"]
  }
  root_block_device {
        volume_type = "gp2"
        volume_size = "10"
  }
    user_data =<<HERE
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.main.name} > /etc/ecs/ecs.config
yum install -y nc
yum install -y nmap-ncat
export IP=`curl -s http://api.ipify.org/`
nohup bash -c 'while printf "HTTP/1.0 200 OK\r\n\r\n$IP $I" | nc -l 9090; do I=$((I+1)); done'  &> /dev/null &
nohup ncat -l 3309 --keep-open --exec "/bin/cat" &> /dev/null &
HERE
}


resource "aws_autoscaling_group" "asg" {
  name                 = "${var.env_name}-main"
  launch_configuration = "${aws_launch_configuration.lc.name}"
  min_size = 0
  max_size = 3
  desired_capacity = 2
  tag {
    key = "Environment"
    value = "${var.env_name}"
    propagate_at_launch = true
  }
  tag {
    key = "Terraformed"
    value = "1"
    propagate_at_launch = true
  }
  vpc_zone_identifier = ["${aws_subnet.a.id}"]
}
