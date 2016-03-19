output "id" {
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

output "public_subnets" {
  value = "${join(",",aws_subnet.public-subnet.*.id)}"
}

output "private_subnets" {
  value = "${join(",",aws_subnet.private-subnet.*.id)}"
}
