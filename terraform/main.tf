module "vpc" {
  source = "modules/vpc-nat-box"

  project     = "${var.project}"
  environment = "${var.environment}"
  region      = "${var.region}"
  cidr_block  = "${var.cidr_block}"
  key_name    = "${var.key_name}"
}
