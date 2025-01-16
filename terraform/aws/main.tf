data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devops_portfolio_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devops_portfolio_main_gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "devops_portfolio_main_route_table"
  }
}

resource "aws_route_table_association" "a" {
  count = 2
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public.id
}

locals {
 policies = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}

resource "aws_iam_role" "eks_cluster_role" {
  name =  "eks-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "eks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags = {
    Name = "devops_portfolio_eks_role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  role = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks_node_role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  
  tags = {
    Name = "devops_portfolio_eks_node_role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_role_attachment" {
  for_each = toset(local.policies)
  role = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}

resource "aws_eks_cluster" "main" {
  name = "devops_eks_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.public_subnet.*.id
  }

  tags = {
    Name = "devops_portfolio_eks_cluster"
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name = aws_eks_cluster.main.name
  node_group_name = "main_eks_node_group"
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = aws_subnet.public_subnet.*.id

  scaling_config {
    min_size = 1
    max_size = 2
    desired_size = 2
  }

  tags = {
    Name = "devops_portfolio_eks_node_group"
  }
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}
