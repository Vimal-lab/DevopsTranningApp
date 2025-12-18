output cluster_url {
  value       = aws_eks_cluster.ekscluster.endpoint
  sensitive   = true
  description = "eks cluster url"
}

output "cluster_name" {
  value       = aws_eks_cluster.ekscluster.name
  description = "EKS cluster name"
}

output "app_elb_security_group_id" {
  value       = aws_security_group.app_elb_sg.id
  description = "Security group ID to attach to the Classic ELB Service"
}