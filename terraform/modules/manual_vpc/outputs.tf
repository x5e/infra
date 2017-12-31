
output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_a" {
  value = "${aws_subnet.a.id}"
}

output "subnet_b" {
  value = "${aws_subnet.b.id}"
}