output "la_workspace_id" {
  value = azurerm_log_analytics_workspace.analytics.workspace_id
}

output "la_workspace_long_id" {
  value = azurerm_log_analytics_workspace.analytics.id
}

output "la_workspace_primary_shared_key" {
  value     = azurerm_log_analytics_workspace.analytics.primary_shared_key
  sensitive = true
}
output "ai_instrumentation_key" {
  value = azurerm_application_insights.appinsights.instrumentation_key
  sensitive = true
}

output "ai_app_id" {
  value = azurerm_application_insights.appinsights.app_id
}

output "ai_connection_string" {
  value = azurerm_application_insights.appinsights.connection_string
  sensitive = true
}

