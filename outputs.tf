# Output some useful variables
output "master_public_dns" {
  value = "${module.openshift.master_public_dns}"
}

output "master_public_ip" {
  value = "${module.openshift.master_public_ip}"
}

output "master_private_dns" {
  value = "${module.openshift.master_private_dns}"
}

output "master_private_ip" {
  value = "${module.openshift.master_private_ip}"
}

output "node_public_dns" {
  value = "${module.openshift.node_public_dns}"
}

output "node_public_ip" {
  value = "${module.openshift.node_public_ip}"
}

output "node_private_dns" {
  value = "${module.openshift.node_private_dns}"
}

output "node_private_ip" {
  value = "${module.openshift.node_private_ip}"
}

output "jumpgate_public_dns" {
  value = "${module.openshift.jumpgate_public_dns}"
}

output "jumpgate_public_ip" {
  value = "${module.openshift.jumpgate_public_ip}"
}

output "jumpgate_private_dns" {
  value = "${module.openshift.jumpgate_private_dns}"
}

output "jumpgate_private_ip" {
  value = "${module.openshift.jumpgate_private_ip}"
}
