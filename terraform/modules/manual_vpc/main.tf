
resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags {
    Name = "${var.env_name}-vpc"
    Environment = "${var.env_name}"
    Terraformed = 1
  }
}

resource "aws_subnet" "a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.100.1.0/24"
  availability_zone = "${var.env_region}a"
  map_public_ip_on_launch = true
  tags {
    Environment = "${var.env_name}"
    Terraformed = "1"
    Name = "${var.env_name}-a"
  }
}

resource "aws_subnet" "b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.100.2.0/24"
  availability_zone = "${var.env_region}b"
  map_public_ip_on_launch = true
  tags {
    Environment = "${var.env_name}"
    Terraformed = "1"
    Name = "${var.env_name}-b"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.env_name}-gateway"
    Environment = "${var.env_name}"
    Terraformed = 1
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}