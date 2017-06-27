variable "region" {
  description = "The AWS region to deploy the cluster in"

  # Passed in via module call in main.tf
}

variable "ami_size" {
  description = "Size of the OpenShift EC2 Instances"

  # Passed in via module call in main.tf
}

variable "key_name" {
  description = "Key Pair name for logging into AWS instances"

  # Passed in via module call in main.tf
}

variable "public_key_path" {
  description = "Public key to use for SSH access"

  # Passed in via module call in main.tf
}

variable "master_count" {
  description = "Number of OpenShift master servers"

  # Passed in via module call in main.tf
}

variable "node_count" {
  description = "Number of OpenShift node servers"

  # Passed in via module call in main.tf
}

variable "vpc_cidr" {
  description = "CIDR address for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR address for the subnet"
  default     = "10.0.1.0/24"
}

variable "subnet_az" {
  description = "Availability zone"
  default     = "us-east-2a"
}
