output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_resource_group_name" {
  value = azurerm_virtual_network.vnet.resource_group_name
}

output "vnet_location" {
  value = azurerm_virtual_network.vnet.location
}

output "vnet_address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

output "vnet_subnets" {
  value = { for subnet in azurerm_virtual_network.vnet.subnet : subnet.name => subnet }
}

output "vnet_guid" {
  value = azurerm_virtual_network.vnet.guid
}
