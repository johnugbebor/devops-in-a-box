variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "devops-eks-demo"
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}