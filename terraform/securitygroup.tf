resource "aws_security_group" "allow-ssh" {
  vpc_id      = "${data.aws_vpc.vpc.id}"
  name        = "allow-ssh"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow-ELB-${var.stage}-${var.stage}"
  }
}

resource "aws_iam_instance_profile" "test_devops" {
  name = "test-devops-${var.stage}-${var.stage}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  name = "test-devops-${var.stage}-${var.stage}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}