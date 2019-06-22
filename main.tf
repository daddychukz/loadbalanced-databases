provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

module "compute" {
  source                 = "./compute"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  public_key_path        = "${var.public_key_path}"
  aws_instance_subnet_id = "${module.vpc.public_subnets}"
  master_sg              = "${module.vpc.master_sg_id}"
}

#------------- VPC -----------

module "vpc" {
  source                   = "./vpc"
  cidrs                    = "${var.cidrs}"
  vpc_cidr                 = "${var.vpc_cidr}"
  availability_zones_names = "${data.aws_availability_zones.available.names}"
}
