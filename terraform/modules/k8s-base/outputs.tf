output "k8s_pipeline_namespace" {
  value = kubernetes_namespace.pipelines.metadata[0].name
}
