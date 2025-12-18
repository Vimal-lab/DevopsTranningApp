output "repository_url" {
  value       = aws_ecr_repository.app.repository_url
  description = "ECR repository URL (use as image prefix)"
}

