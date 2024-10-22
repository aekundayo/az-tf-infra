output "administrator_login_username" {
  value = azurerm_postgresql_flexible_server.postgres.administrator_login
}


output "administrator_login_password" {
  sensitive = true
  value     = resource.random_password.administrator_login_password.result
}

output "db_usr_login_password" {
  sensitive = true
  value     = resource.random_password.db_usr_password.result
}

#output "database_name" {
#  sensitive = true
#  value     = azurerm_postgresql_flexible_server_database.ds_web.name
#}



output "database_host" {
  sensitive = true
  value     = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "hostname" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "db_zone_name" {
  sensitive = true
  value     = azurerm_private_dns_zone.db_zone.name
  }
