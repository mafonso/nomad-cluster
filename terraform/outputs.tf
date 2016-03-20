output "vpc_id" {
  value = "${module.vpc.vpc_id}"
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

output "vpc_public_subnet_ids" {
  value = "${module.vpc.public_subnet_ids}"
}

output "vpc_private_subnet_ids" {
  value = "${module.vpc.private_subnet_ids}"
}

output "vpc_public_subnets_cidrs" {
  value = "${module.vpc.public_subnet_cidrs}"
}

output "vpc_private_subnets_cidrs" {
  value = "${module.vpc.private_subnet_cidrs}"
}
