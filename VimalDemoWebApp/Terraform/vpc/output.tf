output "vpc_id" {
  value       = aws_vpc.devops_project.id
  description = "VPC ID"
}

output "public_subnet_1_id" {
  value       = aws_subnet.public_subnet_1.id
  description = "Public Subnet 1 ID"
}
output "public_subnet_2_id" {
  value       = aws_subnet.public_subnet_2.id
  description = "Public Subnet 2 ID"
}

output "private_subnet_1_id" {
  value       = aws_subnet.private_subnet_1.id
  description = "Private Subnet 1 ID"
}

output "private_subnet_2_id" {
  value       = aws_subnet.private_subnet_2.id
  description = "Private Subnet 2 ID"
}
