locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags      = var.default_tags
}



#resource "azurerm_container_app_environment" "ds_container_app_env" {
#  name                       = var.managed_environment_name
#  location                   = var.location
#  resource_group_name        = var.resource_group_name
#  infrastructure_subnet_id   = var.subnet_id
#  internal_load_balancer_enabled = true
#  log_analytics_workspace_id = var.la_workspace_long_id
#}

resource "azapi_resource" "containerapp_environment" {
  type      = "Microsoft.App/managedEnvironments@2023-04-01-preview"
  schema_validation_enabled = false
  name      = var.managed_environment_name
  parent_id = var.resource_group_id
  location  = var.location
 
  body = jsonencode({
    properties = {

      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = var.la_workspace_id
          sharedKey  = var.primary_shared_key
        }
      }
      vnetConfiguration = {
        internal               = true
        infrastructureSubnetId = var.subnet_id
  
      }
      workloadProfiles = [
        {
          workloadProfileType = "Consumption"
          name = "Consumption"
      }]
        
    }
  })
  
  response_export_values  = ["properties.defaultDomain", "properties.staticIp"]
  ignore_missing_property = true
}


resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = jsondecode(azapi_resource.containerapp_environment.output).properties.defaultDomain
  resource_group_name = var.resource_group_name
  depends_on = [
    azapi_resource.containerapp_environment,
  ]
}
 
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "containerapplink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.virtual_network_id
  depends_on = [
    azapi_resource.containerapp_environment,
    azurerm_private_dns_zone.private_dns_zone
  ]

}
 
resource "azurerm_private_dns_a_record" "containerapp_record" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = ["${jsondecode(azapi_resource.containerapp_environment.output).properties.staticIp}"]
  depends_on = [
    azapi_resource.containerapp_environment,
    azurerm_private_dns_zone.private_dns_zone
  ]
}
