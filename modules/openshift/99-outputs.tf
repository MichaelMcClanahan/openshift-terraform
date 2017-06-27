# Output some useful variables
output "master_public_dns" {
  value = "${aws_instance.master.public_dns}"
}

output "master_public_ip" {
  value = "${aws_instance.master.public_ip}"
}

output "master_private_dns" {
  value = "${aws_instance.master.private_dns}"
}

output "master_private_ip" {
  value = "${aws_instance.master.private_ip}"
}

output "node_public_dns" {
  value = "${aws_instance.node.*.public_dns}"
}

output "node_public_ip" {
  value = "${aws_instance.node.*.public_ip}"
}

output "node_private_dns" {
  value = "${aws_instance.node.*.private_dns}"
}

output "node_private_ip" {
  value = "${aws_instance.node.*.private_ip}"
}

output "jumpgate_public_dns" {
  value = "${aws_instance.jumpgate.public_dns}"
}

output "jumpgate_public_ip" {
  value = "${aws_instance.jumpgate.public_ip}"
}

output "jumpgate_private_dns" {
  value = "${aws_instance.jumpgate.private_dns}"
}

output "jumpgate_private_ip" {
  value = "${aws_instance.jumpgate.private_ip}"
}
