data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.this.certificate_authority[0].data
  )
  token            = data.aws_eks_cluster_auth.this.token
  load_config_file = false
}

resource "kubectl_manifest" "app" {
  depends_on = [
    aws_eks_node_group.this
  ]

  yaml_body = file("${path.module}/k8s/order/deployment-app.yaml")
}
