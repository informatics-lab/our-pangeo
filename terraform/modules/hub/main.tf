data "template_file" "hub-bootstrap" {
    template            = "${file("${path.module}/files/bootstrap.sh")}"
    vars = {
      host_env_file = "${var.host_env_file}"
      jade-secrets-file = "${var.jade-secrets-file}"
      environment = "${var.environment}"
    }
}

resource "aws_instance" "jadehub" {
  ami                   = "ami-f9dd458a"
  instance_type         = "t2.large"
  key_name              = "gateway"
  user_data             = "${data.template_file.hub-bootstrap.rendered}"
  iam_instance_profile  = "jade-secrets"
  security_groups        = ["default", "${aws_security_group.jadehub.name}"]
  tags = {
    Name = "${var.hub-name}"
    OfficeHours = "false"
  }

  root_block_device = {
    volume_size = 20
  }
}

resource "aws_security_group" "jadehub" {
  name = "${var.hub-name}"
  description = "Allow jade traffic"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_from_worker" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"

    security_group_id = "${aws_security_group.jadehub.id}"
    source_security_group_id = "${var.worker_security_group_id}"
}

resource "aws_route53_record" "jupyter" {
  zone_id = "Z3USS9SVLB2LY1"
  name = "${var.dns}."
  type = "A"
  ttl = "60"
  records = ["${aws_instance.jadehub.public_ip}"]
}
