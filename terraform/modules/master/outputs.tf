output "private_ip" {
  value = "${aws_instance.jademaster.private_ip}"
}

output "master_security_group_id" {
  value = "${aws_security_group.jademaster.id}"
}
