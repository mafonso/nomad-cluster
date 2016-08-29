provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.project}-${var.environment}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Managed_by  = "terraform"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Mame        = "${var.project}-${var.environment}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Managed_by  = "terraform"
  }
}

resource "aws_eip" "nat-gw" {
  count = "${var.az_count}"
  vpc   = true
}

data "aws_availability_zones" "azs" {}

resource "aws_nat_gateway" "default" {
  count         = "${var.az_count}"
  allocation_id = "${element(aws_eip.nat-gw.*.id,count.index)}"
  subnet_id     = "${element(aws_subnet.private-subnet.*.id,count.index)}"

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  count                   = "${var.az_count}"
  cidr_block              = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 1), 4, count.index)}"
  availability_zone       = "${data.aws_availability_zones.azs.names[count.index]}"
  map_public_ip_on_launch = false

  tags {
    Name        = "private-${data.aws_availability_zones.azs.names[count.index]}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private_rt" {
  count  = "${var.az_count}"
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.default.*.id,count.index)}"
  }

  tags {
    Name        = "${var.project}-${var.environment}-private"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Managed_by  = "terraform"
  }
}

resource "aws_route_table_association" "private_rta" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.private-subnet.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.private_rt.*.id, count.index)}"
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_internet_gateway.default.*.id,count.index)}"
  }

  tags {
    Name        = "${var.project}-${var.environment}-public"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Managed_by  = "terraform"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  count                   = "${var.az_count}"
  cidr_block              = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 2), 4, count.index)}"
  availability_zone       = "${data.aws_availability_zones.azs.names[count.index]}"
  map_public_ip_on_launch = false

  tags {
    Name        = "private-${data.aws_availability_zones.azs.names[count.index]}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.public-subnet.*.id,count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
