output "pip_id" {
  value = azurerm_public_ip.pip.id
}

output "pip_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}
output "tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}

output "user_assigned_principal_id" {
  value = azurerm_user_assigned_identity.base.principal_id
}

output "user_assigned_id" {
  value = azurerm_user_assigned_identity.base.id
}