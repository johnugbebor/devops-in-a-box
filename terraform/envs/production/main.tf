provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

provider "kubernetes" {
  #load_config_file = "false"
  host                   = data.aws_eks_cluster.app-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.app-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.app-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "app-cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}


data "aws_eks_cluster_auth" "app-cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.21.0"
  name            = var.vpc_name
  cidr            = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.available.names
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/app-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/app-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/app-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }

}
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.36.0"
  cluster_version = "1.31"
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    worker-nodes-prod = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.large"]
      key_name       = "eks_key"

    }
  }

}
