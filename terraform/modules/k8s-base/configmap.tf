resource "kubernetes_config_map" "ansible_project" {
  metadata {
    name      = var.ansible_configmap_name
    namespace = kubernetes_namespace.pipelines.metadata[0].name
  }

  binary_data = {
    "${var.ansible_configmap_zip_filename}" = filebase64(var.ansible_codebase_local_zip_filepath)
  }
}
