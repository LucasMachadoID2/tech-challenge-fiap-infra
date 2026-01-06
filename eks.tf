resource "aws_eks_cluster" "this" {
  name     = "tech-challenge-eks"
  role_arn = data.aws_iam_role.eks_cluster.arn
  version  = "1.29"

  vpc_config {
    subnet_ids = [
      "subnet-068e259ae144edb0e",
      "subnet-0d7b6abad5df63724"
    ]
  }
}
