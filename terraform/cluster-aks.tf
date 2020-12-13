
resource "azurerm_kubernetes_cluster" "aks-worker" {
  name                = "aks-worker"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  dns_prefix          = "aks-worker"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = var.environment
  }
}

