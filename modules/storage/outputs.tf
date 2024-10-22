output "name" {
  value = azurerm_storage_account.eccods.name
}

output "key" {
  value = azurerm_storage_account.eccods.primary_access_key
  sensitive = true
}

output "static_website_endpoint" {
  value = azurerm_storage_account.eccods.primary_web_endpoint
}

output "static_connection_string" {
  value = azurerm_storage_account.eccods.primary_connection_string
  sensitive = true
}

