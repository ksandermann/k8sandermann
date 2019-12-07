resource "azurerm_resource_group" "aks" {
  name     = var.aks_rg_name
  location = var.aks_location
}

resource "azurerm_kubernetes_cluster" "cluster001" {
  name                = var.aks_cluster_name
  location            = var.aks_location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.aks_dns_prefix

  default_node_pool {
    name       = "linux-${var.aks_node_type}"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_type
  }

  service_principal {
    client_id     = var.aks_svc_principal_client_id
    client_secret = var.aks_svc_principal_client_secret
  }

}
