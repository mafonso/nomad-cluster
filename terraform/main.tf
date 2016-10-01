provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "config" {
  bucket = "${var.organization}-${var.project}-${var.environment}-config"
  acl    = "private"

  tags {
    Name        = "${var.project}-${var.environment}"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }

  lifecycle {
    prevent_destroy = false
  }
}

module "vpc" {
  source = "modules/vpc-nat-box"

  project             = "${var.project}"
  environment         = "${var.environment}"
  region              = "${var.region}"
  az_count            = 3
  cidr_block          = "${var.cidr_block}"
  key_name            = "${var.key_name}"
  domain_name_servers = "${var.domain_name_servers}"
}

module "bastion" {
  source = "modules/bastion"

  project     = "${var.project}"
  environment = "${var.environment}"
  region      = "${var.region}"

  vpc_id          = "${module.vpc.vpc_id}"
  subnets         = "${module.vpc.public_subnet_ids}"
  key_name        = "${var.key_name}"
  security_groups = "${module.vpc.default_security_group_id}"
}

module "consul" {
  source = "modules/asg-elb"

  role        = "consul"
  project     = "${var.project}"
  environment = "${var.environment}"
  region      = "${var.region}"

  vpc_id               = "${module.vpc.vpc_id}"
  subnets              = "${module.vpc.private_subnet_ids}"
  key_name             = "${var.key_name}"
  security_groups      = "${module.vpc.default_security_group_id}"
  instance_type        = "t2.micro"
  iam_instance_profile = "s3-config-bucket"

  min_size         = 1
  max_size         = 3
  desired_capacity = 3
}

module "nomad" {
  source = "modules/asg-elb"

  role        = "nomad"
  project     = "${var.project}"
  environment = "${var.environment}"
  region      = "${var.region}"

  vpc_id               = "${module.vpc.vpc_id}"
  subnets              = "${module.vpc.private_subnet_ids}"
  key_name             = "${var.key_name}"
  security_groups      = "${module.vpc.default_security_group_id}"
  instance_type        = "t2.micro"
  iam_instance_profile = "s3-config-bucket"

  min_size         = 1
  max_size         = 3
  desired_capacity = 3
}

module "worker" {
  source = "modules/asg-elb"

  role        = "worker"
  project     = "${var.project}"
  environment = "${var.environment}"
  region      = "${var.region}"

  vpc_id               = "${module.vpc.vpc_id}"
  subnets              = "${module.vpc.private_subnet_ids}"
  key_name             = "${var.key_name}"
  security_groups      = "${module.vpc.default_security_group_id}"
  instance_type        = "t2.micro"
  iam_instance_profile = "s3-config-bucket"

  min_size         = 1
  max_size         = 3
  desired_capacity = 3
}
