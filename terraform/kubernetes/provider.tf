provider "kubernetes" {
  host = var.host
  cluster_ca_certificate = var.certificate
  token = var.token
}

provider "helm" {
  kubernetes {
    host = var.host
    cluster_ca_certificate = var.certificate
    token = var.token
  }
}
