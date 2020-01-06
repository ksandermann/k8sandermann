terraform {
  required_version = "0.12.17"
  backend "azurerm" {
    key = "workspace_k8s.tfstate"
  }
}


provider "azurerm" {
  version = "1.38.0"
}
