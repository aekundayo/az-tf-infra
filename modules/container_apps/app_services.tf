locals {
  should_use_log_analytics = (var.la_workspace_long_id == "" ? false : true)
}

# Diagnostic settings for each web app - start
#resource "azurerm_monitor_diagnostic_setting" "wa_diagnostic_logs" {
#  for_each = tomap({ for k, v in azurerm_linux_web_app.wa : k => v.id if local.should_use_log_analytics })
#
#  name                       = "${var.app_service_plan_name}-diagnostic-logs"
#  target_resource_id         = each.value
#  log_analytics_workspace_id = var.la_workspace_long_id
#
#  log {
#    category = "AppServiceAppLogs"
#    enabled  = true
#    retention_policy {
#      days    = 0
#      enabled = false
#    }
#  }
#
#  log {
#    category = "AppServiceAuditLogs"
#    enabled  = true
#    retention_policy {
#      days    = 0
#      enabled = false
#    }
#  }
#
#  log {
#    category = "AppServiceConsoleLogs"
#    enabled  = true
#    retention_policy {
#      days    = 0
#      enabled = false
#    }
#  }
#
#  log {
#    category = "AppServiceHTTPLogs"
#    enabled  = true
#    retention_policy {
#      days    = 0
#      enabled = false
#    }
#  }
#
#  log {
#    category = "AppServiceIPSecAuditLogs"
#    enabled  = true
#    retention_policy {
#      days    = 0
#      enabled = false
#    }
#  }
#
#  log {
#    category = "AppServicePlatformLogs"
#    enabled  = true
#    retention_policy {
#      days    = 0
#      enabled = false
#    }
#  }
#
#  metric {
#    category = "AllMetrics"
#    enabled  = "true"
#
#    retention_policy {
#      enabled = "true"
#      days    = "30"
#    }
#  }
#}
#