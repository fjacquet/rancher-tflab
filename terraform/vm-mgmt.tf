
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




resource "azurerm_windows_virtual_machine" "mgmt" {
  count                      = var.count-mgmt
  name                       = "mgmt${count.index}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  network_interface_ids      = [azurerm_network_interface.mgmt[count.index].id]
  availability_set_id        = azurerm_availability_set.aset-rancher.id
  size                       = var.mgmt-size
  computer_name              = "mgmt${count.index}"
  admin_username             = var.vm-user
  admin_password             = var.vm-passwd
  enable_automatic_updates   = true
  provision_vm_agent         = true
  encryption_at_host_enabled = false

  identity {
    type = "SystemAssigned"
  }

  winrm_listener {
    protocol = "Http"
  }


  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "19h2-pro-g2"
    version   = "latest"
  }

  os_disk {
    name                 = "disk-os-mgmt${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  tags = {
    environment = var.environment
    role        = "mgmt"
  }

}
resource "azurerm_virtual_machine_extension" "ext-install-mgmt" {
  count                = var.count-mgmt
  name                 = "ext-install-mgmt${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.mgmt[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath install.ps1\" && powershell -ExecutionPolicy Unrestricted -File install.ps1"
  }
  SETTINGS


  tags = {
    environment = var.environment
  }
}

data "template_file" "tf" {
  template = file("../powershell/install-client.ps1")
}
