provider "azurerm" {
  version = "~> 1.38.0"
}

module "k8s-jobs" {
  source = "./../../modules/k8s-jobs"

  aks_cluster_name    = var.aks_cluster_name
  aks_cluster_rg_name = var.aks_cluster_rg_name
}
