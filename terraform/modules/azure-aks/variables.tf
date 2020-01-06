variable "aks_cluster_rg_name" {}
variable "aks_location" {}
variable "aks_cluster_name" {}
variable "aks_node_count" {}
variable "aks_node_type" {}
variable "aks_svc_principal_client_id" {}
variable "aks_svc_principal_client_secret" {}
variable "aks_dns_prefix" {}
variable "aks_kubernetes_version" {}
variable "aks_node_os_disk_gb" {}

variable "aks_network_service_cidr" {
  type    = string
  default = "10.10.10.0/24"
}

locals {
  aks_resource_tags = {
    stage       = "devops"
    purpose     = "pipelines"
    persistent  = "no"
    k8s_version = var.aks_kubernetes_version
    node_rg     = "${var.aks_cluster_name}_ClusterResources"
  }
}
