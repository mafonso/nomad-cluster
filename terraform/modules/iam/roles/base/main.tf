resource "aws_iam_role" "role" {
  name = "${var.project}-${var.environment}-${var.role}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
         "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  name  = "${var.project}-${var.environment}-${var.role}"
  roles = ["${aws_iam_role.role.name}"]
}

resource "aws_iam_role_policy" "policy" {
  count = "${length(split(",",var.policy_list))}"
  name  = "${element(split(",",var.policy_list),count.index)}"

  role = "${aws_iam_role.role.id}"

  policy = "${file("policies/${element(split(",",var.policy_list),count.index)}")}"
}
