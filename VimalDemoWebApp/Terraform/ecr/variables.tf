variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region"
}

variable "repository_name" {
  type        = string
  default     = "vimal-demo-webapp"
  description = "ECR repository name for the application image"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "MUTABLE or IMMUTABLE"
}

