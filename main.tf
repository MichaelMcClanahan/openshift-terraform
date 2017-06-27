# Create provider to setup into AWS
provider "aws" {
  region = "${var.region}"
}

# Create OpenShift cluster using a module
module "openshift" {
  source = "./modules/openshift"
  region = "${var.region}"

  ami_size        = "${var.ami_size}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  master_count    = "${var.master_count}"
  node_count      = "${var.node_count}"
}
