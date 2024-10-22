output "redis_key" {
  value = azurerm_redis_cache.ds.primary_access_key
  sensitive = true
}

output "redis_connection_string" {
  value = azurerm_redis_cache.ds.primary_connection_string
  sensitive = true
}


output "redis_host_name" {
  value = azurerm_redis_cache.ds.hostname
}

output "redis_ip" {
  value = azurerm_redis_cache.ds.private_static_ip_address
}