# Create eks cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks_cluster"
  role_arn = var.eks_role_arn

  version = "1.30"
  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

# Create eks node group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_role_arn = var.node_role_arn
  node_group_name = "eks-node-group"
  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.micro"]

}