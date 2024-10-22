
resource "azurerm_public_ip" "pip" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_nat_gateway" "nat_gtw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
}




resource "azurerm_nat_gateway_public_ip_association" "natg-pip-ass" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gtw.id
  public_ip_address_id = azurerm_public_ip.pip.id
}



resource "azurerm_subnet_nat_gateway_association" "associations" {
  count = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  nat_gateway_id = azurerm_nat_gateway.nat_gtw.id
}


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
