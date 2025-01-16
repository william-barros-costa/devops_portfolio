module "aws" {
  source = "./aws"
}

module "kubernetes" {
  source = "./kubernetes"
  node_group = module.aws.node_group
  cluster_name = module.aws.cluster_name
  token = module.aws.token
  host = module.aws.host
  certificate = module.aws.certificate
}

