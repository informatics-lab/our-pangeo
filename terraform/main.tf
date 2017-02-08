module "master" {
  source = "../modules/master"
  host_env_file = "${var.host_env_file}"
  jade-secrets-file = "${var.jade-secrets-file}"
  environment  = "${var.environment}"
  master-name = "${var.master-name}"
  dns = "${var.dns}"
  slave_security_group_id = "${module.slave.slave_security_group_id}"
}

module "slave" {
  source = "../modules/slave"
  worker-name = "${var.worker-name}"
  master_security_group_id = "${module.master.master_security_group_id}"
  master_private_ip = "${module.master.private_ip}"
}
