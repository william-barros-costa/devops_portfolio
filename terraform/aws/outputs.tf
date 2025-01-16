output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "The security group ID of the EKS cluster"
  value = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value = module.eks.cluster_name
}
