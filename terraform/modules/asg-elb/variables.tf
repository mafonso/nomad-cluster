variable "project" {}

variable "organization" {}

variable "environment" {}

variable "region" {}

variable "key_name" {}

variable "vpc_id" {}

variable "role" {}

variable "instance_type" {}

variable "iam_instance_profile" {}

variable "security_groups" {}

variable "enable_monitoring" {
  default = "false"
}

variable "ebs_optimized" {
  default = false
}

variable "volume_type" {
  default = "gp2"
}

variable "volume_size" {
  default = "8"
}

variable "volume_delete_on_termination" {
  default = "true"
}

variable "subnets" {
  type = "list"
}

variable "min_size" {}

variable "max_size" {}

variable "desired_capacity" {}

variable "health_check_grace_period" {
  default = "300"
}

variable "health_check_type" {
  default = "EC2"
}

variable "force_delete" {
  default = "false"
}
