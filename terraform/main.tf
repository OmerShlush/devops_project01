data "aws_caller_identity" "current" {}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "devops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name                         = var.cluster_name
  cluster_version                      = "1.31"
  cluster_endpoint_public_access       = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 1
      desired_size = 1
      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
      subnets        = module.vpc.private_subnets
    }
  }

  create_kms_key = false
  cluster_encryption_config = []

  access_entries = {
    github_ci = {
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/github-actions-deploy"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


resource "aws_ecr_repository" "hw_webapp" {
  name                 = "hw_webapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


