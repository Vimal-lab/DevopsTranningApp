variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region"
}

variable "bucket_prefix" {
  type        = string
  default     = "devops-training-tfstate"
  description = "Prefix for the Terraform state bucket name (a random suffix will be added for uniqueness)"
}

variable "dynamodb_table_name" {
  type        = string
  default     = "terraform-locks"
  description = "DynamoDB table name for state locking"
}


