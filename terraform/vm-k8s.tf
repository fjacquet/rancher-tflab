
resource "azurerm_network_interface" "k8s" {
  count                         = var.count-k8s
  name                          = "nic-k8s${count.index}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  enable_accelerated_networking = var.enable_accelerated_networking
  ip_configuration {
    name                          = "pip-k8s${count.index}"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s[count.index].id
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface_security_group_association" "k8s" {
  count                     = var.count-k8s
  network_interface_id      = azurerm_network_interface.k8s[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-k8s.id
}

resource "azurerm_network_security_group" "nsg-k8s" {
  name                = "nsg-k8s-https"
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
    source_address_prefix      = "${var.myip}/32"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "k8s" {
  count                   = var.count-k8s
  network_interface_id    = azurerm_network_interface.k8s[count.index].id
  ip_configuration_name   = "pip-k8s${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
}


resource "azurerm_public_ip" "k8s" {
  count               = var.count-k8s
  name                = "pip-k8s${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  ip_version          = "IPv4"
}



resource "azurerm_linux_virtual_machine" "k8s" {
  count                 = var.count-k8s
  name                  = "k8s${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.k8s[count.index].id]
  availability_set_id   = azurerm_availability_set.aset-k8s.id
  size                  = var.k8s-size
  computer_name         = "k8s${count.index}"
  admin_username        = var.vm-user

  custom_data = base64encode(
    templatefile(
      join("/", [path.module, "cloud-common/files/userdata_rancher_server.template"]),
      {
        docker_version = var.docker_version
        username       = var.vm-user
      }
    )
  )
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.sku
    version   = "latest"
  }
  os_disk {
    name                 = "disk-os-k8s${count.index}"
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
    role        = "k8s"
  }
}

# resource "azurerm_virtual_machine_extension" "custom-ext-k8s" {
#   count                = var.count-k8s
#   name                 = "custom-ext-k8s${count.index}"
#   virtual_machine_id   = azurerm_linux_virtual_machine.k8s[count.index].id
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
