# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
  environment     = "public"
  subscription_id = "fcb2e9e2-5c8b-405d-91d4-e780b50549ed"
  tenant_id       = "6adf23d8-eabe-44c8-b68a-0b8fb7aacef9"

}