data "azurerm_dns_zone" "parent" {

  provider            = azurerm.dev_subscription
  name                = local.zone_name
  resource_group_name = local.tf_static_rg_name
}
