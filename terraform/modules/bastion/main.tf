provider "aws" {
  region = "${var.region}"
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
  subnet_id                   = "${element(module.vpc.public_subnet_ids,1)}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}", "${module.vpc.default_security_group_id}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.key_name}"

  tags {
    Name = "Bastion"
  }
}