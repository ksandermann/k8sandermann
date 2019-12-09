resource "azurerm_resource_group" backend {
  name     = var.backend_resource_group_name
  location = var.backend_resource_group_location
}

module "azurerm-backend" {
  //TODO switch to tag
  source = "git::https://github.com/ksandermann/terraform-azurerm-backend.git?ref=init"

  backend_resource_group_name              = azurerm_resource_group.backend.name
  backend_storage_account_name             = var.backend_storage_account_name
  backend_storage_container_name           = var.backend_storage_container_name
  backend_resource_tags                    = var.backend_resource_tags
  backend_storage_account_replication_type = var.backend_storage_account_replication_type
  backend_storage_account_tier             = var.backend_storage_account_tier

}
