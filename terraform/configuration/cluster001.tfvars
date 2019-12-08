//workspace aks-cluster
aks_cluster_rg_name             = "pipelineCluster001"
aks_location                    = "westeurope"
aks_cluster_name                = "pipelineCluster001"
aks_node_count                  = "1"
aks_node_type                   = "Standard_B2s"
aks_svc_principal_client_id     = "cba59eda-4964-43d7-96fa-216dcaff1cb6"
aks_svc_principal_client_secret = "1db3eacd-c597-4aeb-acb0-3ec104f355c4"
aks_dns_prefix                  = "pipelineCluster001"
aks_kubernetes_version          = "1.14.8"
aks_node_os_disk_gb             = "4"

//workspace k8s
k8s_pipeline_namespace              = "pipelines"
ansible_configmap_name              = "ansible-codebase"
ansible_configmap_zip_filename      = "ansible.zip"
ansible_codebase_local_zip_filepath = "/root/project/ansible.zip"

//pipeline_configs = {
//  dockeransible = {
//    name = "dockeransible"
//  }
//
//  dockerhelm = {
//    name = "dockerhelm"
//  }
//}

//pipeline_configs = [
//  {
//    name   = "dockerhelm"
//    number = 1
//  },
//  {
//    name   = "dockeransible"
//    number = 2
//  },
//]

