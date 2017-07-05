#!/usr/bin/env bash
# This script template will prepare a VM to run OpenShift.
## See: https://docs.openshift.org/latest/install_config/install/host_preparation.html
## And: https://docs.openshift.org/latest/install_config/install/advanced_install.html

# Log everything.
set -x
exec > /var/log/user-data.log 2>&1

# Install the following base packages:
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
yum update -y

# It doesn't appear that Docker is in the standard RedHat repo.
# See: https://forums.aws.amazon.com/thread.jspa?messageID=574126
yum-config-manager --enable rhui-REGION-rhel-server-extras

# Docker setup.
yum install -y docker

# Update the Docker config to allow OpenShift's local insecure registry.
sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16 --log-opt max-size=1M --log-opt max-file=3"' \
  /etc/sysconfig/docker
systemctl restart docker

# Note we are not configuring Docker storage as per the guide.
