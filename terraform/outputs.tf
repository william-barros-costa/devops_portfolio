output "argo_cd_website" {
  value = module.kubernetes.argocd_server_load_balancer
}

output "eks_connect" {
  value = "aws eks --region eu-west-1 update-kubeconfig --name ${module.aws.cluster_name}"
}

output "admin_secret" {
  value = module.kubernetes.argocd_initial_admin_secret
}

output "cluster_name" {
  value = module.aws.cluster_name
}

output "region" {
  value = module.aws.region
}
