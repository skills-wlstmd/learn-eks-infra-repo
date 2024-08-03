locals {
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  region          = "ap-northeast-2"
  vpc_id          = var.vpc_id
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  tag = {
    Environment = "test"
    Terraform   = "true"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # Cluster Name Setting
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  # Cluster Endpoint Setting
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Network Setting
  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnets

  # IRSA Enable / OIDC 구성
  enable_irsa = true

  # Cluster addons
  cluster_addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {}
  }

  node_security_group_additional_rules = {}

  # Tag Node Security Group
  node_security_group_tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }

  eks_managed_node_groups = {
    initial = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.large"]

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  # Cluster access entry
  enable_cluster_creator_admin_permissions = true

  access_entries = var.create_access_entry ? {
    admin_user = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::<AWSID>:user/admin"
    }
  } : {}
}

// private subnet tag
resource "aws_ec2_tag" "private_subnet_tag" {
  for_each    = toset(local.private_subnets)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  for_each    = toset(local.private_subnets)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.cluster_name}"
  value       = "owned"
}

resource "aws_ec2_tag" "private_subnet_karpenter_tag" {
  for_each    = toset(local.private_subnets)
  resource_id = each.value
  key         = "karpenter.sh/discovery/${local.cluster_name}"
  value       = local.cluster_name
}

// public subnet tag
resource "aws_ec2_tag" "public_subnet_tag" {
  for_each    = toset(local.public_subnets)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}