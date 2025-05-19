provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}


module "myapp-vpc" {
  source =   "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.available.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/app-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/app-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/app-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

}
