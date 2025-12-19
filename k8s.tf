data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}


provider "kubectl" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}

# 1. Secret
resource "kubectl_manifest" "secret" {
  depends_on = [aws_eks_node_group.this]
  yaml_body  = file("${path.module}/k8s/order/secrets.yaml")
}

# 2. ConfigMap
resource "kubectl_manifest" "configmap" {
  depends_on = [aws_eks_node_group.this]
  yaml_body  = file("${path.module}/k8s/order/configmap.yaml")
}

# 3. Database Deployment
resource "kubectl_manifest" "database_deployment" {
  depends_on = [kubectl_manifest.secret, kubectl_manifest.configmap]
  yaml_body  = file("${path.module}/k8s/order/deployment-database.yaml")
}

# 4. Database Service
resource "kubectl_manifest" "database_service" {
  depends_on = [kubectl_manifest.database_deployment]
  yaml_body  = file("${path.module}/k8s/order/service-database.yaml")
}

# 5. App Deployment
resource "kubectl_manifest" "app_deployment" {
  depends_on = [kubectl_manifest.secret, kubectl_manifest.configmap, kubectl_manifest.database_service]
  yaml_body  = file("${path.module}/k8s/order/deployment-app.yaml")
}

# 6. App Service
resource "kubectl_manifest" "app_service" {
  depends_on = [kubectl_manifest.app_deployment]
  yaml_body  = file("${path.module}/k8s/order/service-app.yaml")
}
