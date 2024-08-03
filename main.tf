module "eks" {
  # eks 모듈에서 사용할 변수 정의
  source = "./modules/eks-cluster"
  cluster_name = "learn-eks-cluster"
  cluster_version = "1.30"
  vpc_id = "<VPCID>"

  private_subnets = ["<private-subnetID-1>", "<private-subnetID-2>"]
  public_subnets  = ["<public-subnetID-1>", "<public-subnetID-2>"]
}