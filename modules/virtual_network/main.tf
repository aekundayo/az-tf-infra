resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  location            = var.location
  tags                = var.default_tags
  

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
      security_group = subnet.value.network_security_group_id
    }
  }

  dynamic "ddos_protection_plan" {
    for_each = var.env == "prod" ? [1] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }
}



// patch subnets service endpoints
// patch subnets delegations
# resource "azapi_update_resource" "ur" {
#   for_each = { for subnet in azurerm_virtual_network.vnet.subnet : subnet.name => subnet }

#   type       x = "Microsoft.Network/virtualNetworks/subnets@2021-03-01"
#   resource_id = each.value.id

#   body = jsonencode({
#     properties = {
#       service_endpoints = ["Microsoft.Web"]
#     }
#   })

# }
#resource "azapi_update_resource" "subnet_patching" {
#  
#  for_each = { for subnet in var.subnets : subnet.name => subnet }
#  type = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"  
#  name = each.value.name  
#  parent_id = azurerm_virtual_network.vnet.id  
#  body = jsonencode({
#    properties = {
#      delegations = each.value.delegations != "" ? each.value.delegations : []
#      
#    }
#  })
#}





#resource "azurerm_subnet" "da" {
#  name                 = "database-subnet"
#  resource_group_name  = var.name
#  virtual_network_name = azurerm_virtual_network.example.name
#  address_prefixes     = ["10.0.1.0/24"]
#
#    delegation {
#    name = "dbdelegation"
#
#    service_delegation {
#      name = "Microsoft.DBforPostgreSQL/flexibleServers"
#
#      actions = [
#        "Microsoft.Network/virtualNetworks/subnets/join/action",
#      ]
#    }
#  }
#}
