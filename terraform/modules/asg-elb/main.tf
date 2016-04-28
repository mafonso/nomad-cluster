provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "sg_asg" {
  description = "${var.role} security group"
  vpc_id      = "${var.vpc_id}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags {
    name        = "${var.project}-${var.environment}"
    role        = "${var.role}"
    project     = "${var.project}"
    environment = "${var.environment}"
    managed_by  = "terraform"
  }
}

resource "aws_launch_configuration" "lc" {
  name_prefix       = "${var.role}"
  image_id          = "${var.ami}"
  instance_type     = "${var.instance_type}"
  key_name          = "${var.key_name}"
  security_groups   = ["${aws_security_group.sg_asg.id}", "${var.security_groups}"]
  enable_monitoring = "${var.enable_monitoring}"
  ebs_optimized     = "${var.ebs_optimized}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.volume_delete_on_termination}"
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "asg-${var.environment}-${var.role}"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  launch_configuration      = "${aws_launch_configuration.lc.id}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  force_delete              = "${var.force_delete}"
  vpc_zone_identifier       = ["${split(",",var.subnets)}"]

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "managed_by"
    value               = "autoscaling"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "${var.role}"
    propagate_at_launch = true
  }
}
