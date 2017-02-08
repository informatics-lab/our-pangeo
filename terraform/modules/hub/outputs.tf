output "private_ip" {
  value = "${aws_instance.jadehub.private_ip}"
}

output "hub_security_group_id" {
  value = "${aws_security_group.jadehub.id}"
}
