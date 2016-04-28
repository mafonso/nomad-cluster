variable "project" {
}

variable "environment" {
}

variable "region" {
}

variable "key_name" {
}

variable "vpc_id" {
}

variable "role" {
}

variable "ami" {
}

variable "instance_type" {
}

variable "security_groups" {
}

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
}

variable "min_size" {
}

variable "max_size" {
}

variable "health_check_grace_period" {
  default = "300"
}

variable "health_check_type" {
  default = "EC2"
}

variable "force_delete" {
  default = "false"
}
