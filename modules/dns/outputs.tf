output "dns_zone_name" {
  value = azurerm_dns_zone.parent.name
}

output "resource_group_name" {
  value = azurerm_dns_zone.parent.resource_group_name
}

output "name_servers" {
  value = azurerm_dns_zone.parent.name_servers
}
