resource "azurerm_key_vault_secret" "these" {
  for_each = var.keyvault_secrets 

  key_vault_id = var.key_vault_id # Static value
  name         = each.key  # Dynamically set the name
  value        = each.value.value  # Dynamically set the value
  content_type = each.value.content_type  # Dynamically set the content type
}