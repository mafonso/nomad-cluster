module "vpc" {
  source = "modules/vpc"

  name        = "${var.vpc_name}"
  region      = "${var.region}"
  cidr_block  = "${var.cidr_block}"
  key_name    = "${var.key_name}"

