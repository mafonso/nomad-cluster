output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "cidr_block" {
  value = "${aws_vpc.default.cidr_block}"
}

output "default_security_group_id" {
  value = "${aws_vpc.default.default_security_group_id}"
}

output "default_network_acl_id" {
  value = "${aws_vpc.default.default_network_acl_id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public-subnet.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private-subnet.*.id}"]
}

output "public_subnet_cidrs" {
  value = ["${aws_subnet.public-subnet.*.cidr_block}"]
}

output "private_subnet_cidrs" {
  value = ["${aws_subnet.private-subnet.*.cidr_block}"]
}
