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

# Create OpenShift jumpgate server
resource "aws_instance" "jumpgate" {
  ami           = "${data.aws_ami.amazon_linux.id}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-ssh.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  tags {
    Name    = "OpenShift Jumpgate"
    Project = "openshift"
  }
}
