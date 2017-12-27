
resource "aws_iam_role" "role" {
    name = "${var.env_name}-ecs-instance"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "profile" {
  role = "${aws_iam_role.role.name}"
  name = "${var.env_name}-ecs-instance"
}

resource "aws_iam_role_policy_attachment" "attach_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = "${aws_iam_role.role.name}"
}


resource "aws_iam_role_policy_attachment" "attach_ecs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "attach_logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  role = "${aws_iam_role.role.name}"
}