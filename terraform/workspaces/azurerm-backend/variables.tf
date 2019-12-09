variable "backend_resource_group_name" {
  type        = string
  description = "Name of the resource group the storage account should be placed in. Needs to be created outside of this module."
}

variable "backend_resource_group_location" {
  type        = string
  description = "Location of the resource group the storage account should be placed in. Needs to be created outside of this module."
  default     = "westeurope"
}

variable "backend_resource_tags" {
  type        = map(string)
  description = "Tags to add to the storage account resources."
}

variable "backend_storage_account_name" {
  type        = string
  description = "Name of the storage account. Will be transformed to a valid format using local regex."
}

variable "backend_storage_account_tier" {
  type        = string
  description = "Tier of the storage account"
  default     = "Standard"
}

variable "backend_storage_account_replication_type" {
  type        = string
  description = "Replication type of the storage account"
  default     = "LRS"
}

variable "backend_storage_container_name" {
  type        = string
  description = "Name of the storage container. Will be transformed to a valid format using local regex."
}
