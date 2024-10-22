locals {

  diag_logs = [
    "PostgreSQLLogs",
    "PostgreSQLFlexSessions",
    "PostgreSQLFlexQueryStoreWaitStats",
    "PostgreSQLFlexQueryStoreRuntime"
  ]
  diag_metrics = [
    "AllMetrics",
  ]
}




resource "random_password" "administrator_login_password" {
  length  = 40
  special = false
  override_special = ""
}

resource "random_password" "db_usr_password" {
  length  = 40
  special = false
  override_special = ""
}

resource "azurerm_private_dns_zone" "db_zone" {
  name                = "${var.name}.private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "zone_link" {
  name                  = "database-zone-link"
  private_dns_zone_name = azurerm_private_dns_zone.db_zone.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
  depends_on = [azurerm_private_dns_zone.db_zone]
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "14"
  delegated_subnet_id    = var.delegated_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.db_zone.id
  administrator_login    = "psqladmin"
  administrator_password = resource.random_password.administrator_login_password.result
  storage_mb = var.storage_mb

  zone = "1"
  lifecycle {
    ignore_changes = [
      zone,
      high_availability.0.standby_availability_zone
    ]
  }
 


  sku_name   = var.sku_name
  depends_on = [azurerm_private_dns_zone_virtual_network_link.zone_link]
}

#resource "azurerm_postgresql_flexible_server" "postgres" {
#  name                   = var.name
#  resource_group_name    = var.resource_group_name
#  location               = var.location
#  version                = var.postgres_version
#  delegated_subnet_id    = var.delegated_subnet_id
#  private_dns_zone_id    = azurerm_private_dns_zone.db_zone.id
#  administrator_login    = "psqladmin"
#  administrator_password = resource.random_password.administrator_login_password.result
#  storage_mb             = var.storage_mb
#  sku_name               = var.sku_name
#  zone                   = "1"
#  depends_on = [azurerm_private_dns_zone_virtual_network_link.zone_link]
#  # lifecycle {
#  #     ignore_changes = [
#  #       zone,
#  #       high_availability.0.standby_availability_zone
#  #     ]
#  # }
#}

#resource "azurerm_postgresql_flexible_server_database" "ds_web" {
#  name      = "ds_web_${var.env}"
#  server_id = azurerm_postgresql_flexible_server.postgres.id
#  collation = "en_US.utf8"
#  charset   = "utf8"
#}


resource "azurerm_postgresql_flexible_server_firewall_rule" "allow-ecco-center" {
  name             = "Allow-ECCO-Center"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "185.170.124.11"
  end_ip_address   = "185.170.124.11"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow-ecco-mobile" {
  name             = "Allow-ECCO-Mobile"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "185.170.124.194"
  end_ip_address   = "185.170.124.194"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow01" {
  name             = "Allow01"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "82.201.55.244"  
  end_ip_address   = "82.201.55.244"

}
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow02" {
  name             = "Allow02"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "213.127.66.148"
  end_ip_address   = "213.127.66.148"

}
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow-azure" {
  name             = "AllowAllAzureServicesAndResourcesWithinAzureIps_2021-8-28_10-16-31"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
resource "azurerm_postgresql_flexible_server_firewall_rule" "wfhd" {
  name             = "WfhD"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "77.251.241.249"
  end_ip_address   = "77.251.241.249"
}


resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_postgresql_flexible_server.postgres.id
  log_analytics_workspace_id = var.la_workspace_long_id
  dynamic "log" {
    for_each = local.diag_logs
    content {
      category = log.value

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = local.diag_metrics
    content {
      category = metric.value

      retention_policy {
        enabled = false
      }
    }
  }
}