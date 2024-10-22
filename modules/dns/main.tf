resource "azurerm_dns_zone" "parent" {

  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

