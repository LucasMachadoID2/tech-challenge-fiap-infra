resource "aws_eks_cluster" "this" {
  name     = "tech-challenge-eks"
  role_arn = data.aws_iam_role.eks_cluster.arn
  version  = "1.29"

  vpc_config {
    subnet_ids = [
      "subnet-06cc1d21fa59e4630",
      "subnet-03761aa7a16b7b2bf"
    ]
  }
}
