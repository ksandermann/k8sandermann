provider "kubernetes" {
  version          = "1.8.1"
  load_config_file = false

  host = local.cluster_apiserver_host

  // - Authenticate with AKS API server using cluster admin credentials
  // - I.e. a client certificate/key which is returned by the azurerm_kubernetes_cluster resource

  client_certificate     = local.cluster_admin_client_certificate
  client_key             = local.cluster_admin_client_key
  cluster_ca_certificate = local.cluster_client_ca_certificate
}

locals {
  //using kube_config as rbac is disabled
  cluster_apiserver_host = data.azurerm_kubernetes_cluster.cluster001.kube_config[0].host

  cluster_admin_client_certificate = base64decode(
    data.azurerm_kubernetes_cluster.cluster001.kube_config[0].client_certificate
  )
  cluster_admin_client_key = base64decode(
    data.azurerm_kubernetes_cluster.cluster001.kube_config[0].client_key
  )
  cluster_client_ca_certificate = base64decode(
    data.azurerm_kubernetes_cluster.cluster001.kube_config[0].cluster_ca_certificate
  )
}

