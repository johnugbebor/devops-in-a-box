module "vpc" {

  source    = "../../modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks

}
module "eks" {
  source         = "../../modules/eks"
  region         = var.region
  cluster_name   = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}