resource "azuread_application" "aks_cloud_controller" {
  name = var.aks_cluster_name
}

resource "azuread_service_principal" "aks_cloud_controller" {
  application_id = azuread_application.aks_cloud_controller.application_id
}

resource "random_string" "aks_sp_password" {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.aks_cloud_controller.id
  }
}

resource "azuread_service_principal_password" "aks_cloud_controller" {
  service_principal_id = azuread_service_principal.aks_cloud_controller.id
  value                = random_string.aks_sp_password.result
  end_date             = timeadd(timestamp(), "8760h")

  # This stops be 'end_date' changing on each run and causing a new password to be set
  # to get the date to change here you would have to manually taint this resource...
  lifecycle {
    ignore_changes = [end_date, value]
  }
}


