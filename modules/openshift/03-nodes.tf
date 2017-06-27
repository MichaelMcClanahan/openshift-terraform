# Define RHEL 7.3 AMI by:
# Latest, RedHat, x86_64, EBS, HVM, RHEL 7.3
data "aws_ami" "rhel7_3" {
  most_recent = true

  owners = ["309956199498"] # Red Hat's account ID.

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["RHEL-7.3*"]
  }
}

# Create SSH Key Pair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# Load the script to prepare OpenShift
data "template_file" "prepare_openshift" {
  template = "${file("${path.module}/files/prepare_openshift.sh")}"
}

# Create OpenShift master(s)
resource "aws_instance" "master" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"
  user_data     = "${data.template_file.prepare_openshift.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  root_block_device {
    volume_size = 40
  }

  tags {
    Name    = "OpenShift Master ${format(count.index + 1)}"
    Project = "openshift"
  }

  count = "${var.master_count}"
}

# Create OpenShift node(s)
resource "aws_instance" "node" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"
  user_data     = "${data.template_file.prepare_openshift.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  root_block_device {
    volume_size = 40
  }

  tags {
    Name    = "OpenShift Node ${format(count.index + 1)}"
    Project = "openshift"
  }

  count = "${var.node_count}"
}
