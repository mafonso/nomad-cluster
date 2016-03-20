module "vpc" {
  source = "modules/vpc"

  project       = "${var.project}"
  environment   = "${var.environment}"
  region        = "${var.region}"
  cidr_block    = "${var.cidr_block}"
  key_name      = "${var.key_name}"
}

module "consul-cluster" {
  source = "modules/asg-elb"

  project           = "${var.project}"
  environment       = "${var.environment}"
  region            = "${var.region}"
  key_name          = "${var.key_name}"

  vpc_id            = "${module.vpc.vpc_id}"
  security_groups   = "${module.vpc.default_security_group_id}"

  role              = "consul-cluster"
  ami               = "ami-939b1ee0"
  instance_type     = "t2.small"
  subnets           = "${module.vpc.public_subnet_ids}"

  min_size          = 3
  max_size          = 3
}