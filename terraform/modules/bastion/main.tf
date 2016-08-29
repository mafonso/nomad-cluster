provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "instance_whitelist"
  vpc_id      = "${var.vpc_id}"

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

data "atlas_artifact" "ami" {
  name    = "acme/bastion"
  type    = "amazon.image"
  version = "latest"

  metadata {
    region = "${var.region}"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "${data.atlas_artifact.ami.metadata_full.ami_id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(var.subnets,1)}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}", "${var.security_groups}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.key_name}"

  tags {
    Name = "Bastion"
  }
}
