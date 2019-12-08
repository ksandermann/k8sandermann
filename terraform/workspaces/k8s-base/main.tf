provider "azurerm" {
  version = "~> 1.38.0"
}

module "k8s-base" {
  source = "./../../modules/k8s-base"

  aks_cluster_name    = var.aks_cluster_name
  aks_cluster_rg_name = var.aks_cluster_rg_name
}
