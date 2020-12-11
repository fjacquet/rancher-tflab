
resource "azurerm_network_interface" "rancher" {
  count                         = var.count-rancher
  name                          = "nic-rancher${count.index}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  enable_accelerated_networking = var.enable_accelerated_networking
  ip_configuration {
    name                          = "pip-rancher${count.index}"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rancher[count.index].id
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface_security_group_association" "rancher" {
  count                     = var.count-rancher
  network_interface_id      = azurerm_network_interface.rancher[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-rancher.id
}

resource "azurerm_network_security_group" "nsg-rancher" {
  name                = "nsg-rancher-https"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "rancher" {
  count                   = var.count-rancher
  network_interface_id    = azurerm_network_interface.rancher[count.index].id
  ip_configuration_name   = "pip-rancher${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
}


resource "azurerm_public_ip" "rancher" {
  count               = var.count-rancher
  name                = "pip-rancher${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  ip_version          = "IPv4"
}

resource "azurerm_dns_a_record" "rancher" {
  count               = var.count-rancher
  name                = "a-rancher${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.rancher[count.index].id
}


resource "azurerm_linux_virtual_machine" "rancher" {
  count                 = var.count-rancher
  name                  = "vm-rancher${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.rancher[count.index].id]
  availability_set_id   = azurerm_availability_set.aset-rancher.id
  size                  = var.rancher-size
  computer_name         = "worker${count.index}"
  admin_username        = var.vm-user


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.sku
    version   = "latest"
  }
  os_disk {
    name                 = "disk-os-rancher${count.index}"
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
    role        = "rancher"
  }
}

# resource "azurerm_virtual_machine_extension" "custom-ext-rancher" {
#   count                = var.count-rancher
#   name                 = "custom-ext-rancher${count.index}"
#   virtual_machine_id   = azurerm_linux_virtual_machine.rancher[count.index].id
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