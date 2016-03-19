module "vpc" {
  source = "modules/vpc"

  project       = "${var.project}"
  environment   = "${var.environment}"
  region        = "${var.region}"
  cidr_block    = "${var.cidr_block}"
  keypair_name  = "${var.keypair_name}"

