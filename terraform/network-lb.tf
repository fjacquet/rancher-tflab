
resource "azurerm_public_ip" "pip-lb" {
  name                = "pip-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb-rancher" {
  name                = "lb-rancher"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "basic"
  tags = {
    environment = var.environment
  }
  frontend_ip_configuration {
    name                 = "rancher"
    public_ip_address_id = azurerm_public_ip.pip-lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend" {
  name                = "BackEndAddressPool"
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.lb-rancher.id
}

# Load Balancer Rule

resource "azurerm_lb_rule" "load_balancer_ssh_rule" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.lb-rancher.id
  name                           = "SSHRule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "rancher"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend.id
  probe_id                       = azurerm_lb_probe.load_balancer_ssh_probe.id
  depends_on                     = [azurerm_lb_probe.load_balancer_ssh_probe]
}
resource "azurerm_lb_rule" "load_balancer_http_rule" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.lb-rancher.id
  name                           = "HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "rancher"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend.id
  probe_id                       = azurerm_lb_probe.load_balancer_http_probe.id
  depends_on                     = [azurerm_lb_probe.load_balancer_http_probe]
}

resource "azurerm_lb_rule" "load_balancer_https_rule" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.lb-rancher.id
  name                           = "HTTPSRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "rancher"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend.id
  probe_id                       = azurerm_lb_probe.load_balancer_http_probe.id
  depends_on                     = [azurerm_lb_probe.load_balancer_http_probe]
}

#LB Probe - Checks to see which VMs are healthy and available
resource "azurerm_lb_probe" "load_balancer_ssh_probe" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.lb-rancher.id
  name                = "SSH"
  port                = 22
}
resource "azurerm_lb_probe" "load_balancer_http_probe" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.lb-rancher.id
  name                = "HTTP"
  port                = 80
}


# resource "azurerm_lb_rule" "ssh" {
#   resource_group_name            = azurerm_resource_group.main.name
#   loadbalancer_id                = azurerm_lb.lb-rancher.id
#   name                           = "SSH"
#   protocol                       = "Tcp"
#   frontend_port                  = 22
#   backend_port                   = 22
#   frontend_ip_configuration_name = "rancher"
# }

# resource "azurerm_lb_rule" "http" {
#   resource_group_name            = azurerm_resource_group.main.name
#   loadbalancer_id                = azurerm_lb.lb-rancher.id
#   name                           = "HTTP"
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = "rancher"
# }

# resource "azurerm_lb_rule" "KubeAPI" {
#   resource_group_name            = azurerm_resource_group.main.name
#   loadbalancer_id                = azurerm_lb.lb-rancher.id
#   name                           = "KubeAPI"
#   protocol                       = "Tcp"
#   frontend_port                  = 6443
#   backend_port                   = 6443
#   frontend_ip_configuration_name = "rancher"
# }

# resource "azurerm_lb_rule" "https" {
#   resource_group_name            = azurerm_resource_group.main.name
#   loadbalancer_id                = azurerm_lb.lb-rancher.id
#   name                           = "HTTPS"
#   protocol                       = "Tcp"
#   frontend_port                  = 443
#   backend_port                   = 443
#   frontend_ip_configuration_name = "rancher"
# }

# resource "azurerm_lb_probe" "ssh" {
#   resource_group_name = azurerm_resource_group.main.name
#   loadbalancer_id     = azurerm_lb.lb-rancher.id
#   name                = "ssh-running-probe"
#   port                = "22"
# }


# resource "azurerm_lb_probe" "KubeAPI" {
#   resource_group_name = azurerm_resource_group.main.name
#   loadbalancer_id     = azurerm_lb.lb-rancher.id
#   name                = "kubeapi-running-probe"
#   port                = "6443"
# }

# resource "azurerm_lb_probe" "https" {
#   resource_group_name = azurerm_resource_group.main.name
#   loadbalancer_id     = azurerm_lb.lb-rancher.id
#   name                = "https-running-probe"
#   port                = "443"
# }


# resource "azurerm_lb_probe" "http" {
#   resource_group_name = azurerm_resource_group.main.name
#   loadbalancer_id     = azurerm_lb.lb-rancher.id
#   name                = "http-running-probe"
#   protocol            = "Http"
#   port                = 80
#   request_path        = "/"
# }
