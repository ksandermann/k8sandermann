variable "aks_cluster_rg_name" {}
variable "aks_cluster_name" {}
variable "k8s_pipeline_namespace" {}
variable "ansible_configmap_name" {}
variable "ansible_configmap_zip_filename" {}

//variable "pipeline_configs" {
//  default = [
//    "dockeransible": {        name = "dockeransible"    },
//    "dockerhelm": {      name = "dockerhelm"    }
//  ]
//
//  type = map(object({
//    name = string
//  }))
//}

variable "networks" {
  type = map(object({
    nameeins = string
    namezwei = string
  }))

  default = {
    ansible = {
      nameeins = "ansible1"
      namezwei = "ansible2"
    }
    helm = {
      nameeins = "helm1"
      namezwei = "helm1"
    }
  }
}


//locals {
//  //  pcfgs = flatten([
//  //    for resource in keys(var.pipeline_configs) : [
//  //      for p in var.pipeline_configs[resource] : {
//  //        resource = resource
//  //        ppname   = p.name
//  //      }
//  //    ]
//  //  ])
//  //
//  //  pipelinemap = {
//  //    for s in local.pcfgs : "${s.resource}:${s.ppname}" => s
//  //  }
//
//  example = [
//    for cfg in var.pipeline_configs : {
//      name = cfg.name
//    }
//  ]
//}
