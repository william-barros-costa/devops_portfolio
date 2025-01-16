output "region" {
  description = "AWS region"
  value = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value = aws_eks_cluster.main.name
}

output "node_group" {
  description = "Node Group used to create Argo"
  value = aws_eks_node_group.main
}

output "host" {
  description = "Kubernetes endpoint"
  value = aws_eks_cluster.main.endpoint
}

output "token" {
  description = "Kubernetes endpoint"
  value = data.aws_eks_cluster_auth.main.token
}

output "certificate" {
  description = "Kubernetes certificate authority's client certificate"
  value = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
}

