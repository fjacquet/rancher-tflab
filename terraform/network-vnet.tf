
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = [var.vnet-main]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet-main]

}

# resource "azurerm_application_security_group" "asg-main" {
#   name                = "asg-main"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   tags = {
#     Hello = "World"
#   }
# }