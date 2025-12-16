resource "aws_eks_cluster" "this" {
  name     = "tech-challenge-eks"
  role_arn = data.aws_iam_role.eks_cluster.arn
  version  = "1.29"

  vpc_config {
    subnet_ids = [
      "subnet-088b6448367295809",
      "subnet-04571b8bf7398dd2e"
    ]
  }
}
