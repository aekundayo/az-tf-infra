
#data "azurerm_virtual_network" "vnet2" {
#    count = var.execution_count
#  provider            = azurerm.lower_subscription
#  name                = var.lower_vnet_name
#  resource_group_name = var.lower_vnet_rg_name
#}
#
#data "azurerm_client_config" "example" {}
#
#
#
#resource "azurerm_virtual_network_peering" "peer1to2" {
#    count = var.execution_count
#  name                      = var.peering1to2_name
#  resource_group_name       = var.resource_group_name
#  virtual_network_name      = var.vnet_name
#  remote_virtual_network_id = "/subscriptions/${var.lower_subscription_id}/resourceGroups/rg-DigitalShowroom-dev-westeurope-001/providers/Microsoft.Network/virtualNetworks/${var.lower_vnet_name}"
#  allow_forwarded_traffic   = true
#}
#
#resource "azurerm_virtual_network_peering" "peer2to1" {
#    count = var.execution_count
#  provider = azurerm.lower_subscription
#  name                      = var.peering2to1_name
#  resource_group_name       = var.lower_vnet_rg_name
#  virtual_network_name      = var.lower_vnet_name
#  remote_virtual_network_id = "/subscriptions/${data.azurerm_client_config.example.subscription_id}/resourceGroups/rg-DigitalShowroom-test-westeurope-001/providers/Microsoft.Network/virtualNetworks/${var.vnet_name}"
#  allow_forwarded_traffic   = true
#}
