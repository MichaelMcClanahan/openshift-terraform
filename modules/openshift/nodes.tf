# Define RHEL 7.3 AMI
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

# Define Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["137112412989"]

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
    values = ["amzn-ami-hvm-*"]
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

# Create OpenShift infra node(s)
resource "aws_instance" "infra" {
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
    Name    = "OpenShift Infra ${format(count.index + 1)}"
    Project = "openshift"
  }

  count = "${var.infra_count}"
}

# Create OpenShift jumpgate server
resource "aws_instance" "jumpgate" {
  ami           = "${data.aws_ami.amazon_linux.id}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"
  user_data     = "${data.template_file.prepare_openshift.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-ssh.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  tags {
    Name    = "OpenShift Jumpgate"
    Project = "openshift"
  }

  provisioner "file" {
    source      = "${path.module}/files/inventory.cfg"
    destination = "/etc/ansible/hosts"
  }

  # provisioner "remote-exec" {
  #   script = "${path.module}/files/deploy.sh"

  #   connection {
  #     host                = "${aws_instance.master.private_ip}"
  #     user                = "ec2-user"
  #     private_key         = "${file("/Users/michaelmcclanahan/.ssh/id_rsa")}"
  #     bastion_host        = "${aws_instance.jumpgate.public_dns}"
  #     bastion_user        = "ec2-user"
  #     bastion_private_key = "${file("/Users/michaelmcclanahan/.ssh/id_rsa")}"
  #   }
  # }
}
