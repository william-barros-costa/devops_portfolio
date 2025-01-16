variable "cluster_name" {
  description = "Kubernetes Cluster name"
  type = string
}

variable "node_group" {
  description = "Kubernetes node group"
}

variable "host" {
  description = "Kubernetes endpoint"
}

variable "certificate" {
  description = "Kubernetes Client Certificate"
}

variable "token" {
  description = "Kubernetes client token"
}
