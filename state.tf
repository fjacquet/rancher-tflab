terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "demosastatetf"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}