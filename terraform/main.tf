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
    prevent_destroy = true
  }
}

module "vpc" {
  source = "modules/vpc-nat-box"

  project     = "${var.project}"
  environment = "${var.environment}"
  region      = "${var.region}"
  az_count    = 3
  cidr_block  = "${var.cidr_block}"
  key_name    = "${var.key_name}"
}

module "consul" {
  source = "modules/asg-elb"

  role        = "consul"
  project     = "${var.project}"
  environment = "${var.environment}"
  region      = "${var.region}"
  key_name    = "${var.key_name}"

  vpc_id               = "${module.vpc.vpc_id}"
  subnets              = "${module.vpc.private_subnet_ids}"
  security_groups      = "${module.vpc.default_security_group_id}"
  instance_type        = "t2.micro"
  iam_instance_profile = "s3-config-bucket"

  min_size         = 1
  max_size         = 3
  desired_capacity = 3
}




