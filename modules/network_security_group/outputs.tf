output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}

output "nsga_id" {
  value = length(azurerm_subnet_network_security_group_association.nsga) > 0 ? one(azurerm_subnet_network_security_group_association.nsga).id : null
}
