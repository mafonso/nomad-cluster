provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    name        = "${var.project}-${var.environment}"
    project     = "${var.project}"
    environment = "${var.environment}"
    managed_by  = "terraform"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    name        = "${var.project}-${var.environment}"
    project     = "${var.project}"
    environment = "${var.environment}"
    managed_by  = "terraform"
  }
}

resource "aws_eip" "nat-eip" {
  count    = "${length(split(",", lookup(var.azs, var.region)))}"
  instance = "${element(aws_instance.nat.*.id,count.index)}"
  vpc      = true
}

data "atlas_artifact" "nat" {
  name    = "acme/nat"
  type    = "amazon.image"
  version = "latest"

  metadata {
    region = "${var.region}"
  }
}

resource "aws_instance" "nat" {
  count                       = "${length(split(",", lookup(var.azs, var.region)))}"
  ami                         = "${data.atlas_artifact.nat.metadata_full.ami_id}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${element(aws_subnet.public-subnet.*.id,count.index)}"
  associate_public_ip_address = true
  source_dest_check           = false

  tags {
    Name        = "${var.project}-${var.environment}-nat"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Managed_by  = "terraform"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  count                   = "${length(split(",", lookup(var.azs, var.region)))}"
  cidr_block              = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 1), 4, count.index)}"
  availability_zone       = "${element(split(",", lookup(var.azs, var.region)), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name        = "private-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private_rt" {
  count  = "${length(split(",", lookup(var.azs, var.region)))}"
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${element(aws_instance.nat.*.id,count.index)}"
  }

  tags {
    name        = "${var.project}-${var.environment}-private"
    project     = "${var.project}"
    environment = "${var.environment}"
    managed_by  = "terraform"
  }
}

resource "aws_route_table_association" "private_rta" {
  count          = "${length(split(",", lookup(var.azs, var.region)))}"
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
    name        = "${var.project}-${var.environment}-public"
    project     = "${var.project}"
    environment = "${var.environment}"
    managed_by  = "terraform"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  count                   = "${length(split(",", lookup(var.azs, var.region)))}"
  cidr_block              = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 2), 4, count.index)}"
  availability_zone       = "${element(split(",", lookup(var.azs, var.region)), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name        = "public-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = "${length(split(",", lookup(var.azs, var.region)))}"
  subnet_id      = "${element(aws_subnet.public-subnet.*.id,count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
