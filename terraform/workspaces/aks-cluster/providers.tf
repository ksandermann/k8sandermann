terraform {
  required_version = "0.12.17"
  backend "azurerm" {}
}


provider "azurerm" {
  version = "1.38.0"
}

provider "azuread" {
  version = "0.3.1"
}

provider "random" {
  version = "2.2.1"
}
