
resource "azurerm_network_interface" "worker" {
  count                         = var.count-worker
  name                          = "nic-worker${count.index}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "pip-worker${count.index}"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.worker[count.index].id
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "worker" {
  count                   = var.count-worker
  network_interface_id    = azurerm_network_interface.worker[count.index].id
  ip_configuration_name   = "pip-worker${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
}

resource "azurerm_public_ip" "worker" {
  count               = var.count-worker
  name                = "pip-worker${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  ip_version          = "IPv4"
}

resource "azurerm_dns_a_record" "worker" {
  count               = var.count-worker
  name                = "a-worker${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.worker[count.index].id
}


resource "azurerm_linux_virtual_machine" "worker" {
  count                 = var.count-worker
  name                  = "vm-worker${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.worker[count.index].id]
  availability_set_id   = azurerm_availability_set.aset-rancher.id
  size                  = var.worker-size
  computer_name         = "worker${count.index}"
  admin_username        = var.vm-user


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.sku
    version   = "latest"
  }
  os_disk {
    name                 = "disk-os-worker${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.vm-user
    public_key = tls_private_key.global_key.public_key_openssh
  }


  tags = {
    environment = var.environment
    engine      = "docker"
    role        = "worker"
  }

}

resource "azurerm_managed_disk" "worker" {
  count                = var.count-worker
  name                 = "disk-data-worker${count.index}"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

resource "azurerm_virtual_machine_data_disk_attachment" "worker" {
  count              = var.count-worker
  managed_disk_id    = azurerm_managed_disk.worker[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.worker[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}

# resource "azurerm_virtual_machine_extension" "custom-ext-worker" {
#   count                = var.count-worker
#   name                 = "custom-ext-worker${count.index}"
#   virtual_machine_id   = azurerm_linux_virtual_machine.worker[count.index].id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "hostname && uptime"
#     }
# SETTINGS


#   tags = {
#     environment = var.environment
#   }
# }