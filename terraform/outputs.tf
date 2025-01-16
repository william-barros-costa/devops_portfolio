output "region" {
  value = module.aws.region
}

output "cluster_name" {
  value = module.aws.cluster_name
}

output "load_balancer" {
  value = module.kubernetes.argocd_server_load_balancer
}

output "admin_secret" {
  value = module.kubernetes.argocd_initial_admin_secret
  t }
