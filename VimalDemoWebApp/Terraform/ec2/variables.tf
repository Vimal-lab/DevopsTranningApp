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

variable ami_image {
  type        = string
  default     = "ami-01760eea5c574eb86"
  description = "Amazon linux image id"
}

variable instance_type {
  type        = string
  default     = "t2.micro"
  description = "Developement server"
}

variable sshkeyname {
  type        = string
  default     = "keypairinstance1"
  description = "EC2 key pair name for SSH (not a .pem file path)"
}

variable "root_volume_size_gb" {
  type        = number
  default     = 50
  description = "EC2 root volume size (GiB)"
}


variable "admin_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR allowed to SSH to EC2 (restrict to your public IP/32 for real use)"
}


variable commontag {
  type        = string
  default     = "devops_project"
  description = ""
}