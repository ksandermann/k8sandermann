resource "kubernetes_namespace" "pipelines" {
  metadata {
    name = var.k8s_pipeline_namespace
  }
}
