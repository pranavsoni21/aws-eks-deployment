# Create VPC
module "vpc" {
  source = "./modules/vpc"

  availability_zones  = ["ap-south-1a", "ap-south-1b"]
  private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
  public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_counts       = 2
  vpc_cidr            = "10.0.0.0/16"
  vpc_name            = "eks_vpc"
}

# Create IAM role for eks cluster
module "iam" {
  source = "./modules/iam"
}

# Create EKS cluster
module "eks" {
  source = "./modules/eks"

  eks_role_arn       = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_group_role_arn
  private_subnet_ids = module.vpc.private_subnets
}