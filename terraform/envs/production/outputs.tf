output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_id" {
  value = data.aws_eks_cluster.app-cluster.id
}