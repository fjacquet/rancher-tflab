resource "azurerm_dns_zone" "ljf" {
  name                = "ljf.home"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_dns_a_record" "longhorn" {
  count               = var.count-longhorn
  name                = "a-longhorn${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.longhorn[count.index].id
}

resource "azurerm_dns_a_record" "mgmt" {
  count               = var.count-mgmt
  name                = "a-mgmt${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.mgmt[count.index].id
}


resource "azurerm_dns_a_record" "rancher" {
  count               = var.count-rancher
  name                = "a-rancher${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.rancher[count.index].id
}


resource "azurerm_dns_a_record" "worker" {
  count               = var.count-worker
  name                = "a-worker${count.index}"
  zone_name           = azurerm_dns_zone.ljf.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.worker[count.index].id
}