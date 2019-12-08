resource "azurerm_resource_group" "aks" {
  name     = var.aks_cluster_rg_name
  location = var.aks_location
}

resource "azurerm_kubernetes_cluster" "cluster001" {
  name                = var.aks_cluster_name
  location            = var.aks_location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.aks_kubernetes_version

  default_node_pool {
    name                  = "default"
    node_count            = var.aks_node_count
    vm_size               = var.aks_node_type
    type                  = "VirtualMachineScaleSets"
    enable_auto_scaling   = false
    enable_node_public_ip = false
    //os_disk_size_gb       = var.aks_node_os_disk_gb
    node_taints        = []
    availability_zones = []
  }

  service_principal {
    client_id     = var.aks_svc_principal_client_id
    client_secret = var.aks_svc_principal_client_secret
  }

  node_resource_group = "${var.aks_cluster_name}_ClusterResources"

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = cidrhost(var.aks_network_service_cidr, 10)
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = var.aks_network_service_cidr
  }

  addon_profile {
    oms_agent {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }
  }

  role_based_access_control {
    enabled = false
  }

  tags = local.aks_resource_tags

}
