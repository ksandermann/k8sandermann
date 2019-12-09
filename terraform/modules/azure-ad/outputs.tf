output "aks_service_principal_client_id" {
  value = azuread_service_principal.aks_cloud_controller.application_id
}

output "aks_service_principal_client_secret" {
  value = azuread_service_principal_password.aks_cloud_controller.value
}
