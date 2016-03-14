provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}


resource "aws_subnet" "private-subnet" {
    vpc_id            = "${aws_vpc.main.id}"
    count             = "${length(split(",", lookup(var.azs, var.region)))}"
    cidr_block        = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 1), 4, count.index)}"
    availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index)}"
    map_public_ip_on_launch = false

    tags {
        "Name" = "private-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    }
}

resource "aws_subnet" "public-subnet" {
    vpc_id            = "${aws_vpc.main.id}"
    count             = "${length(split(",", lookup(var.azs, var.region)))}"
    cidr_block        = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 2), 4, count.index)}"
    availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index)}"
    map_public_ip_on_launch = false

    tags {
        "Name" = "public-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    }
}