variable "region" {
  description = "The AWS region to deploy the cluster in"
  default     = "us-east-2"
}

variable "ami_size" {
  description = "Size of the OpenShift EC2 Instances"
  default     = "t2.large"                            # Smallest that meets the min specs for OS
}

variable "key_name" {
  description = "Key Pair name for logging into AWS instances"
  default     = "openshift"
}

variable "public_key_path" {
  description = "Public key to use for SSH access"
  default     = "~/.ssh/id_rsa.pub"
}

variable "master_count" {
  description = "Number of OpenShift master servers"
  default     = 1
}

variable "node_count" {
  description = "Number of OpenShift node servers"
  default     = 2
}

variable "infra_count" {
  description = "Number of OpenShift infra node servers"
  default     = 1
}
