terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraformedtroleis2"
    container_name       = "tfstate"
    key                  = "dev/aks/aks.terraform.tfstate"
  }
}
