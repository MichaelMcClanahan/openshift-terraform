#!/usr/bin/env bash
yum -y --enablerepo=epel install ansible pyOpenSSL

cd ~
git clone https://github.com/openshift/openshift-ansible\

cat << 'EOF' > /etc/ansible/hosts
# Create an OSEv3 group that contains the masters and nodes groups
[OSEv3:children]
masters
nodes

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root
openshift_disable_check=disk_availability
# openshift_hosted_metrics_deploy=true
openshift_master_default_subdomain=app.pandora.lan

openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]
openshift_master_htpasswd_users={'admin': '$apr1$zgSjCrLt$1KSuj66CggeWSv.D.BXOA1', 'user': '$apr1$.gw8w9i1$ln9bfTRiD6OwuNTG5LvW50'}

# If ansible_ssh_user is not root, ansible_become must be set to true
#ansible_become=true

openshift_deployment_type=origin

# uncomment the following to enable htpasswd authentication; defaults to DenyAllPasswordIdentityProvider
#openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]

# host group for masters
[masters]
${master_public_dns}

# host group for etcd
[etcd]
${master_public_dns}

# host group for nodes, includes region info
[nodes]
${master_public_dns}
#  openshift_node_labels="{'region': 'primary', 'zone': 'east'}"
#  openshift_node_labels="{'region': 'primary', 'zone': 'west'}"
infra-node1.pandora.lan openshift_node_labels="{'region': 'infra', 'zone': 'default'}"
EOF

ansible-playbook ~/openshift-ansible/playbooks/byo/config.yml