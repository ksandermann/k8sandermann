terraform {
  required_version = "0.12.17"
}

provider "azurerm" {
  version = "~> 1.38.0"
}

module "azure-aks" {
  source                          = "./../../modules/azure-aks"
  aks_cluster_name                = var.aks_cluster_name
  aks_dns_prefix                  = var.aks_dns_prefix
  aks_location                    = var.aks_location
  aks_node_count                  = var.aks_node_count
  aks_node_type                   = var.aks_node_type
  aks_cluster_rg_name             = var.aks_cluster_rg_name
  aks_svc_principal_client_id     = var.aks_svc_principal_client_id
  aks_svc_principal_client_secret = var.aks_svc_principal_client_secret
}
