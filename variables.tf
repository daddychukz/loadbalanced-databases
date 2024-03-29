variable "aws_region" {}
variable "aws_profile" {}
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}
variable "cidrs" {
  type = "map"
}
variable "public_key_path" {}
variable "key_name" {}
variable "instance_type" {}
variable "ami" {}