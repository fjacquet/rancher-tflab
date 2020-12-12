
resource "azurerm_network_interface" "longhorn" {
  count                         = var.count-longhorn
  name                          = "nic-longhorn${count.index}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  enable_accelerated_networking = var.enable_accelerated_networking
  ip_configuration {
    name                          = "pip-longhorn${count.index}"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.longhorn[count.index].id
  }
  tags = {
    environment = var.environment
  }
}


resource "azurerm_network_interface_security_group_association" "longhorn" {
  count                     = var.count-longhorn
  network_interface_id      = azurerm_network_interface.longhorn[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-longhorn.id
}

resource "azurerm_network_security_group" "nsg-longhorn" {
  name                = "nsg-longhorn-https"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ports"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "6443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "any"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "46.20.242.61/32"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "longhorn" {
  count                   = var.count-longhorn
  network_interface_id    = azurerm_network_interface.longhorn[count.index].id
  ip_configuration_name   = "pip-longhorn${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
}

resource "azurerm_public_ip" "longhorn" {
  count               = var.count-longhorn
  name                = "pip-longhorn${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  ip_version          = "IPv4"
}



resource "azurerm_linux_virtual_machine" "longhorn" {
  count                 = var.count-longhorn
  name                  = "longhorn${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.longhorn[count.index].id]
  size                  = var.longhorn-size
  availability_set_id   = azurerm_availability_set.aset-rancher.id

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.sku
    version   = "latest"
  }

  os_disk {
    name                 = "disk-os-longhorn${count.index}"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  computer_name  = "longhorn${count.index}"
  admin_username = var.vm-user
  admin_ssh_key {
    username   = var.vm-user
    public_key = tls_private_key.global_key.public_key_openssh
  }

  tags = {
    environment = var.environment
    engine      = "docker"
    role        = "longhorn"
  }
}

resource "azurerm_managed_disk" "longhorn" {
  count                = var.count-longhorn
  name                 = "disk-data-longhorn${count.index}"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.data-size
}

resource "azurerm_virtual_machine_data_disk_attachment" "longhorn" {
  count              = var.count-longhorn
  managed_disk_id    = azurerm_managed_disk.longhorn[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.longhorn[count.index].id
  lun                = "20"
  caching            = "ReadWrite"
}

# resource "azurerm_virtual_machine_extension" "custom-ext-longhorn" {
#   count                = var.count-longhorn
#   name                 = "custom-ext-longhorn${count.index}"
#   virtual_machine_id   = azurerm_linux_virtual_machine.longhorn[count.index].id
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