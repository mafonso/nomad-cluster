variable "project" {}
variable "environment" {}
variable "region" {}
variable "keypair_name" {}

variable "cidr_block" {}

variable "azs" {
    default = {
        "us-west-1" = "us-west-1b,us-west-1c"
        "us-west-2" = "us-west-2a,us-west-2b,us-west-2c"
        "us-east-1" = "us-east-1c,us-west-1d,us-west-1e"
        "eu-west-1" = "eu-west-1a,eu-west-1b,eu-west-1c"
        # use "aws ec2 describe-availability-zones --region us-east-1"
        # to figure out the name of the AZs on every region
    }
}
