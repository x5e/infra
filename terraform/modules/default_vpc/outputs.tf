output "vpc_id" {
  value = "${data.aws_vpc.main.id}"
}

output "subnet_a" {
  value = "${data.aws_subnet.a.id}"
}

output "subnet_b" {
  value = "${data.aws_subnet.b.id}"
}