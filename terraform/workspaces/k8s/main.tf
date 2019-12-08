provider "azurerm" {
  version = "~> 1.38.0"
}

module "k8s-base" {
  source = "./../../modules/k8s-base"

  aks_cluster_name                    = var.aks_cluster_name
  aks_cluster_rg_name                 = var.aks_cluster_rg_name
  ansible_codebase_local_zip_filepath = var.ansible_codebase_local_zip_filepath
  ansible_configmap_name              = var.ansible_configmap_name
  ansible_configmap_zip_filename      = var.ansible_configmap_zip_filename
  k8s_pipeline_namespace              = var.k8s_pipeline_namespace
}

module "k8s-jobs" {
  source = "./../../modules/k8s-jobs"

  aks_cluster_name    = var.aks_cluster_name
  aks_cluster_rg_name = var.aks_cluster_rg_name

  ansible_configmap_name         = var.ansible_configmap_name
  ansible_configmap_zip_filename = var.ansible_configmap_zip_filename
  k8s_pipeline_namespace         = module.k8s-base.k8s_pipeline_namespace
}
