
resource "azurerm_network_interface" "mgmt" {
  count                         = var.count-mgmt
  name                          = "nic-mgmt${count.index}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "pip-mgmt${count.index}"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mgmt[count.index].id
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface_security_group_association" "mgmt" {
  count                     = var.count-mgmt
  network_interface_id      = azurerm_network_interface.mgmt[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt.id
}

resource "azurerm_network_security_group" "nsg-mgmt" {
  name                = "nsg-mgmt-https"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}


resource "azurerm_public_ip" "mgmt" {
  count               = var.count-mgmt
  name                = "pip-mgmt${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  ip_version          = "IPv4"
}

resource "azurerm_dns_a_record" "mgmt" {
  count               = var.count-mgmt
  name                = "a-mgmt${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.mgmt[count.index].id
}


resource "azurerm_linux_virtual_machine" "mgmt" {
  count                 = var.count-mgmt
  name                  = "mgmt${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.mgmt[count.index].id]
  availability_set_id   = azurerm_availability_set.aset-rancher.id
  size                  = var.mgmt-size
  computer_name         = "mgmt${count.index}"
  admin_username        = var.vm-user


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.sku
    version   = "latest"
  }
  os_disk {
    name                 = "disk-os-mgmt${count.index}"
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
    role        = "mgmt"
  }

}

# resource "azurerm_managed_disk" "mgmt" {
#   count                = var.count-mgmt
#   name                 = "disk-data-mgmt${count.index}"
#   location             = azurerm_resource_group.main.location
#   resource_group_name  = azurerm_resource_group.main.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = 100
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "mgmt" {
#   count              = var.count-mgmt
#   managed_disk_id    = azurerm_managed_disk.mgmt[count.index].id
#   virtual_machine_id = azurerm_linux_virtual_machine.mgmt[count.index].id
#   lun                = "10"
#   caching            = "ReadWrite"
# }

# resource "azurerm_virtual_machine_extension" "custom-ext-mgmt" {
#   count                = var.count-mgmt
#   name                 = "custom-ext-mgmt${count.index}"
#   virtual_machine_id   = azurerm_linux_virtual_machine.mgmt[count.index].id
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