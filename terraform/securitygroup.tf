resource "aws_security_group" "allow-ssh" {
  vpc_id      = "${data.aws_vpc.vpc.id}"
  name        = "allow-ssh-${var.version}-${var.stage}"

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

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow-ELB-${var.version}-${var.stage}"
  }
}

resource "aws_iam_instance_profile" "test_devops" {
  name = "test-devops-${var.version}-${var.stage}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  name = "test-devops-${var.version}-${var.stage}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
    role = "${aws_iam_role.role.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}