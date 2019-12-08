variable "aks_cluster_rg_name" {}
variable "aks_cluster_name" {}
variable "k8s_pipeline_namespace" {}
variable "ansible_configmap_name" {}
variable "ansible_configmap_zip_filename" {}

variable "k8s_pipeline_container_unzip_image" {
  default = "ksandermann/multistage-builder:2019-09-17"
}
variable "ansible_codebase_mountpath" {
  default = "/tmp/ansible/"
}
variable "k8s_pipeline_container_workdir" {
  default = "/root/project"
}

variable "pipelineconfigs" {
  type = map(object({
    pipeline_name     = string
    builder_image     = string
    playbook_filename = string
  }))

  default = {
    ansible = {
      pipeline_name     = "ansible"
      builder_image     = "ksandermann/ansible:2.8.5"
      playbook_filename = "hello.yml"
    }
    helm = {
      pipeline_name     = "helm"
      builder_image     = "ksandermann/ansible:2.8.5"
      playbook_filename = "hello.yml"
    }
  }
}
