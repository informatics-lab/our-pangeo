module "hub" {
  source = "../modules/hub"
  host_env_file = "${var.host_env_file}"
  jade-secrets-file = "${var.jade-secrets-file}"
  environment  = "${var.environment}"
  hub-name = "${var.hub-name}"
  dns = "${var.dns}"
  worker_security_group_id = "${module.worker.worker_security_group_id}"
}

module "worker" {
  source = "../modules/worker"
  worker-name = "${var.worker-name}"
  hub_security_group_id = "${module.hub.hub_security_group_id}"
  hub_private_ip = "${module.hub.private_ip}"
}
