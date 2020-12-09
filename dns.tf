resource "azurerm_dns_zone" "ljf" {
  name                = "ljf.home"
  resource_group_name = azurerm_resource_group.main.name
}