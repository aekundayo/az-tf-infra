locals {
#  application_secrets = flatten([
#    for app in var.app_services : [
#      for secret in app.secrets : {
#        "secret_key" = {
#          key   = "app_name.${app.name}.${index(app.secrets, secret)}"
#          value = secret
#        }
#      }
#    ]
#  ])
#}
#
#
#data "azurerm_key_vault_secret" "config_secrets" {
#  for_each = { for _, v in local.application_secrets : v.secret_key.key => v.secret_key.value }
#
#  name         = each.value
#  key_vault_id = var.key_vault_id
}
