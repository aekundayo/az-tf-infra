#output "key_vault_managed_identity_id" {
#  value = [for x in azurerm_linux_web_app.wa : x.identity[0]]
#}
#
#output "web_app_resource_ids" {
#  value     = toset([for x in azurerm_linux_web_app.wa : x.id])
#  sensitive = false
#}
#


output "fqdn_web" {
  value = format("%s.%s",var.containerapp_names[0],"${jsondecode(azapi_resource.containerapp_environment.output).properties.defaultDomain}")
}

output "fqdn_api" {
  value = format("%s.%s",var.containerapp_names[1],"${jsondecode(azapi_resource.containerapp_environment.output).properties.defaultDomain}")
}

output "fqdn_assets" {
  value = format("%s.%s",var.containerapp_names[2],"${jsondecode(azapi_resource.containerapp_environment.output).properties.defaultDomain}")
}
