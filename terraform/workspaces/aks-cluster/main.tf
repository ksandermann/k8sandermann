module "azure-ad" {
  source = "./../../modules/azure-ad"

  aks_cluster_name = var.aks_cluster_name
}

module "azure-aks" {
  source = "./../../modules/azure-aks"

  aks_cluster_name                = var.aks_cluster_name
  aks_dns_prefix                  = var.aks_dns_prefix
  aks_location                    = var.aks_location
  aks_node_count                  = var.aks_node_count
  aks_node_type                   = var.aks_node_type
  aks_cluster_rg_name             = var.aks_cluster_rg_name
  aks_svc_principal_client_id     = module.azure-ad.aks_service_principal_client_id
  aks_svc_principal_client_secret = module.azure-ad.aks_service_principal_client_secret
  aks_kubernetes_version          = var.aks_kubernetes_version
  aks_node_os_disk_gb             = var.aks_node_os_disk_gb
}
