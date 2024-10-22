output "key_vault_uri" {
  value = azurerm_key_vault.key_vault.vault_uri
}

output "id" {
  value = azurerm_key_vault.key_vault.id
  sensitive = true
}

output "name" {
  value = azurerm_key_vault.key_vault.name
  sensitive = true
}