locals {

  diag_logs = [
    "ConnectedClientList"
  ]
  diag_metrics = [
    "AllMetrics",
  ]
}


resource "azurerm_redis_cache" "ds" {
  name                = var.redis_cache_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 2
  family              = "C"
  #sku_name            = var.env == "prod" ? "Premium" : "Standard"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  redis_configuration {
  }
}


resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "redis.cache.windows.net"
  resource_group_name = var.resource_group_name
  depends_on = [
       azurerm_redis_cache.ds
     ]
}


resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "vnet-link-${var.redis_cache_name}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.virtual_network_id

  depends_on = [ azurerm_private_dns_zone.private_dns_zone ]
}

resource "azurerm_private_endpoint" "redis_pe" {
  name                = "pe-${var.redis_cache_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  custom_network_interface_name = "nic-${var.redis_cache_name}"

   private_dns_zone_group {
    name                 = "privatednsrediszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone.id]
  }

  private_service_connection {
    name                           = "peconnection-redis"
    private_connection_resource_id = azurerm_redis_cache.ds.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }
  depends_on = [ azurerm_private_dns_zone.private_dns_zone, azurerm_redis_cache.ds ]
}
data "azurerm_network_interface" "redis_pe_nic" {
  name                = "nic-${var.redis_cache_name}"
  resource_group_name = var.resource_group_name
  depends_on = [ azurerm_private_endpoint.redis_pe ]
}

#resource "azurerm_private_dns_a_record" "rediscache_record" {
#  name                = azurerm_redis_cache.ds.name
#  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
#  resource_group_name = var.resource_group_name
#  ttl                 = 300
#  records             = [data.azurerm_network_interface.redis_pe_nic.private_ip_address]
# 
#}

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