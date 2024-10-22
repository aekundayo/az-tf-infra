data "azurerm_client_config" "current" {}

data "azurerm_key_vault_certificate" "certificate" {
  for_each     = { for target in var.backend_targets : target.name => target }
  name         = each.value.key_vault_cert_name
  key_vault_id = var.vault_id
}

data "azurerm_subscription" "current" {}


