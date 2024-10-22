data "azurerm_subscription" "current" {}

output "tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}
