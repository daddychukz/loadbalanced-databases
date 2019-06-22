
output "master_sg_id" {
  value = "${aws_security_group.master_sg.id}"
}

output "public_subnets" {
  value = "${aws_subnet.public_subnets.id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}