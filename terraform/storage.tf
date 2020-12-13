resource "azurerm_storage_account" "rke-storage" {
  name                     = "stor${random_id.randomizer.hex}"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
