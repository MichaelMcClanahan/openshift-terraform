set -x

# Elevate priviledges, retaining the environment.
sudo -E su

# Install the EPEL repository:
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Disable the EPEL repository globally so that it is not accidentally used
# during later steps of the installation:
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

# Install the packages for Ansible:
yum -y --enablerepo=epel install ansible pyOpenSSL

# pip install -Iv ansible==2.2.0.0

# Clone the openshift-ansible repo, which contains the installer.
cd ~
git clone https://github.com/openshift/openshift-ansible

### OpenShift Configuration File ###
cat << 'EOF' > /etc/ansible/hosts
# Create an OSEv3 group that contains the masters and nodes groups
[OSEv3:children]
masters
nodes

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=ec2-user

# If ansible_ssh_user is not root, ansible_become must be set to true
ansible_become=true

openshift_deployment_type=origin

# uncomment the following to enable htpasswd authentication; defaults to DenyAllPasswordIdentityProvider
#openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]

# host group for masters
[masters]
${aws_instance.master.public_dns}

# host group for etcd
[etcd]
${aws_instance.master.public_dns}

# host group for nodes, includes region info
# This is gross and hacky. Make this better
[nodes]
${aws_instance.master.public_dns}
${aws_instance.node.0.public_dns} openshift_node_labels="{'region': 'primary', 'zone': 'east'}"
${aws_instance.node.1.public_dns} openshift_node_labels="{'region': 'primary', 'zone': 'west'}"
${aws_instance.infra.0.public_dns} openshift_node_labels="{'region': 'infra', 'zone': 'default'}"
${aws_instance.infra.1.public_dns} openshift_node_labels="{'region': 'infra', 'zone': 'default'}"
EOF
### OpenShift Configuration File ###

#ansible-playbook ~/openshift-ansible/playbooks/byo/config.yml
