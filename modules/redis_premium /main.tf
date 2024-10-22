locals {

  diag_logs = [
    "ConnectedClientList"
  ]
  diag_metrics = [
    "AllMetrics",
  ]
}


resource "azurerm_redis_cache" "ds" {
  name                = "redis-${var.app}-${var.env}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 2
  family              = "P"
  #sku_name            = var.env == "prod" ? "Premium" : "Standard"
  sku_name            = "Premium"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  subnet_id           = var.subnet_id
  redis_configuration {
  }
}


resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "redis.cache.windows.net"
  resource_group_name = var.resource_group_name
  #   depends_on = [
  #     azapi_resource.containerapp_environment
  #   ]
}

resource "azurerm_private_dns_a_record" "rediscache_record" {
  name                = azurerm_redis_cache.ds.name
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_redis_cache.ds.private_static_ip_address]
 
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "redislink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.virtual_network_id
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = "redis-diag"
  target_resource_id         = azurerm_redis_cache.ds.id
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