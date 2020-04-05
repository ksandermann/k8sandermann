terraform {
  required_version = "~>0.12"
  backend "azurerm" {
    key = "workspace_aks-cluster.tfstate"
  }
}


provider "azurerm" {
  version = "2.2.0"
  features {}
}

provider "azuread" {
  version = "0.3.1"
}

provider "random" {
  version = "2.2.1"
}
