data "template_file" "master-bootstrap" {
    template            = "${file("${path.module}/files/bootstrap.sh")}"
    vars = {
      host_env_file = "${var.host_env_file}"
      jade-secrets-file = "${var.jade-secrets-file}"
      environment = "${var.environment}"
    }
}

resource "aws_instance" "jademaster" {
  ami                   = "ami-f1949e95"
  instance_type         = "t2.large"
  key_name              = "bastion"
  user_data             = "${data.template_file.master-bootstrap.rendered}"
  iam_instance_profile  = "jade-secrets"
  security_groups        = ["allow_from_bastion", "${aws_security_group.jademaster.name}"]
  tags = {
    Name = "${var.master-name}"
  }

  root_block_device = {
    volume_size = 20
  }
}

resource "aws_security_group" "jademaster" {
  name = "${var.master-name}"
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

    security_group_id = "${aws_security_group.jademaster.id}"
    source_security_group_id = "${var.worker_security_group_id}"
}

resource "aws_route53_record" "jupyter" {
  zone_id = "Z3USS9SVLB2LY1"
  name = "${var.dns}."
  type = "A"
  ttl = "60"
  records = ["${aws_instance.jademaster.public_ip}"]
}
