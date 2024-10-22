# log analytics - start

resource "azurerm_log_analytics_workspace" "analytics" {
  name                = var.la_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "appinsights" {
  name                = var.ai_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.analytics.id
  application_type    = "web"
}