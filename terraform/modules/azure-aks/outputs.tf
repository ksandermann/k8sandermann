output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.cluster001.name
}

output "aks_resource_group_name" {
  value = azurerm_kubernetes_cluster.cluster001.resource_group_name
}
