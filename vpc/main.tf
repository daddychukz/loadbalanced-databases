resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "vpc"
  }
}

#internet gateway

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw"
  }
}

# Route tables

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name = "public"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.cidrs["public"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.availability_zones_names[0]}"

  tags {
    Name = "public"
  }
}
resource "aws_route_table_association" "public_assocs" {
  subnet_id      = "${aws_subnet.public_subnets.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_security_group" "master_sg" {
  name        = "master_sg"
  description = "Used for access to the master instance"
  vpc_id      = "${aws_vpc.vpc.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #MYSQL

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9201
    to_port     = 9201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}