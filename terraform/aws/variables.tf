variable "region" {
  description = "AWS Region"
  type = string
  default = "eu-west-1"
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type = string
  default = "devops_portfolio_cluster"
}
