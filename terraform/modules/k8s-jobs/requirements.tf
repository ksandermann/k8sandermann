data "azurerm_resource_group" "cluster" {
  name = var.aks_cluster_rg_name
}

data "azurerm_kubernetes_cluster" "cluster001" {
  name                = var.aks_cluster_name
  resource_group_name = data.azurerm_resource_group.cluster.name
}

