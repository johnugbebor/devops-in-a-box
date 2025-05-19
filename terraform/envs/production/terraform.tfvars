region         = "eu-west-2"
cluster_name   = "devops-eks-demo-prod"
vpc_name       = "prod_vpc"
vpc_cidr_block = "10.1.0.0/16"

private_subnet_cidr_blocks = [
  "10.1.0.0/22",
  "10.1.4.0/22",
  "10.1.8.0/22"
]

public_subnet_cidr_blocks = [
  "10.1.13.0/24",
  "10.1.14.0/24",
  "10.1.15.0/24"
]

