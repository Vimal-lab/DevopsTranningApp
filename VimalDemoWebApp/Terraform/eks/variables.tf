variable cluster_name {
  type        = string
  default     = "capstone_project"
  description = "eks cluster name"
}

variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region"
}

variable "tf_state_bucket" {
  type        = string
  default     = ""
  description = "S3 bucket used for terraform_remote_state lookups (set by pipeline)"
}

variable "tf_state_region" {
  type        = string
  default     = "ap-south-1"
  description = "Region of the Terraform state bucket"
}

variable "vpc_state_key" {
  type        = string
  default     = "backend/vpc/terraform.tfstate"
  description = "Key/path of the VPC stack state file in the state bucket"
}



variable admin_cidr {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR allowed for SSH to worker nodes (restrict to your public IP/32 for real use)"
}

variable eks_version {
  type        = string
  default     = "1.30"
  description = "eks version to be deployed"
}

variable ssh_key_name {
  type        = string
  default     = "keypairinstance1"
  description = "ssh key for logging in to worker nodes"
}

variable workernode_instance_type {
  type        = string
  default     = "t2.micro"
  description = "description"
}

variable workernode_storage {
  type        = number
  default     = 30
  description = "disk allocated to worker nodes"
}

variable desired_size {
  type        = number
  default     = 2
  description = "desired number of worker nodes"
}
variable maximum_worker_nodes {
  type        = number
  default     = 3
  description = "maximum number of worker nodes"
}

variable min_worker_nodes {
  type        = number
  default     = 1
  description = "min number of worker nodes"
}
variable profile {
  type        = string
  default     = "dev"
  description = "aws resource creation profile"
}