

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    environment = var.environment
  }
}

resource "azurerm_availability_set" "aset-k8s" {
  name                = "aset-k8s"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = var.environment
  }
}