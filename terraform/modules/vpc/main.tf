provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}


resource "aws_eip" "nat-gw" {
    count         = "${length(split(",", lookup(var.azs, var.region)))}"
    vpc = true
}


resource "aws_nat_gateway" "default" {
  count         = "${length(split(",", lookup(var.azs, var.region)))}"
  allocation_id = "${element(aws_eip.nat-gw.*.id,count.index)}"
  subnet_id     = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 1), 4, count.index)}"

  depends_on = ["aws_internet_gateway.default"]
}


resource "aws_subnet" "private-subnet" {
    vpc_id            = "${aws_vpc.default.id}"
    count             = "${length(split(",", lookup(var.azs, var.region)))}"
    cidr_block        = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 1), 4, count.index)}"
    availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index)}"
    map_public_ip_on_launch = false

    tags {
        "Name" = "private-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    }
}

resource "aws_route_table" "private_rt" {
    count   = "${length(split(",", lookup(var.azs, var.region)))}"
    vpc_id  = "${aws_vpc.default.id}"
  route {
    cidr_block = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 1), 4, count.index)}"
    nat_gateway_id = "${element(aws_nat_gateway.default.*.id,count.index)}"
  }
}


resource "aws_subnet" "public-subnet" {
    vpc_id            = "${aws_vpc.default.id}"
    count             = "${length(split(",", lookup(var.azs, var.region)))}"
    cidr_block        = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 2), 4, count.index)}"
    availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index)}"
    map_public_ip_on_launch = false

    tags {
        "Name" = "public-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    }
}


