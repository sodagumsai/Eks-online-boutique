terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "my-eks-cluster-state-bucket"
    key            = "live/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-eks-cluster-state-locking"
    encrypt        = true
    profile        = "terraform"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "network" {
  source               = "../../modules/network"
  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source       = "../../modules/security"
  cluster_name = var.cluster_name
  vpc_id       = module.network.vpc_id
}

module "iam" {
  source       = "../../modules/IAM"
  cluster_name = var.cluster_name
}

module "ecr" {
  source           = "../../modules/ecr"
  repository_names = var.ecr_repository_names
}

module "eks" {
  source             = "../../modules/eks"
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  cluster_role_arn   = module.iam.cluster_role_arn
  node_role_arn      = module.iam.node_role_arn
  private_subnet_ids = module.network.private_subnet_ids
  cluster_sg_id      = module.security.cluster_sg_id
  node_sg_id         = module.security.node_sg_id
}
