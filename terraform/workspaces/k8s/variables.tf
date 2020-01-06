variable "aks_cluster_rg_name" {}
variable "aks_cluster_name" {}
variable "k8s_pipeline_namespace" {}
variable "ansible_configmap_name" {}
variable "ansible_configmap_zip_filename" {}
variable "ansible_codebase_local_zip_filepath" {}

variable "k8s_pipeline_configs" {
  type = map(object({
    pipeline_name     = string
    builder_image     = string
    playbook_filename = string
  }))
}
