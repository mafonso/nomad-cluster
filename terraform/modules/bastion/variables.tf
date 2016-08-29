variable "environment" {}

variable "project" {}

variable "region" {}

variable "vpc_id" {}

variable "subnets" {
  type = "list"
}

variable "key_name" {}

variable "security_groups" {}
