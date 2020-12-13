

resource "random_id" "randomizer" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.main.name
  }
  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    environment = var.environment
  }
}

resource "azurerm_availability_set" "aset-k8s" {
  name                         = "aset-k8s"
  location                     = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  tags = {
    environment = var.environment
  }
}
