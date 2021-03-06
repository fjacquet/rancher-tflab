resource "azurerm_dns_zone" "ljf" {
  name                = "az.evlab.ch"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_dns_a_record" "longhorn" {
  count               = var.count-longhorn
  name                = "longhorn${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.longhorn[count.index].id
}

resource "azurerm_dns_a_record" "mgmt" {
  count               = var.count-mgmt
  name                = "mgmt${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.mgmt[count.index].id
}


resource "azurerm_dns_a_record" "k8s" {
  count               = var.count-k8s
  name                = "k8s${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.k8s[count.index].id
}


resource "azurerm_dns_a_record" "worker" {
  count               = var.count-worker
  name                = "worker${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.worker[count.index].id
}

resource "azurerm_dns_a_record" "rancher" {
  name                = "rancher"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip-lb.id
}