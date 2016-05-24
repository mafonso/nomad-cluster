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

  vpc_id          = "${module.vpc.vpc_id}"
  subnets         = "${module.vpc.private_subnet_ids}"
  security_groups = "${module.vpc.default_security_group_id}"
  instance_type   = "t2.micro"

  min_size         = 1
  max_size         = 3
  desired_capacity = 3
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "instance_whitelist"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "bastion" {
  ami                         = "ami-31328842"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(split(",",module.vpc.public_subnet_ids),1)}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}", "${module.vpc.default_security_group_id}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.key_name}"

  tags {
    Name = "Bastion"
  }
}
