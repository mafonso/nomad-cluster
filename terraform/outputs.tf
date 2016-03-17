output "vpc_id" {
  value = "${module.vpc.id}"
}

output "vpc_cidr_block" {
  value = "${module.vpc.cidr_block}"
}

output "vpc_default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
}

output "vpc_default_network_acl_id" {
  value = "${module.vpc.default_network_acl_id}"
}

output "vpc_public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "vpc_private_subnets" {
  value = "${module.vpc.private_subnets}"
}
