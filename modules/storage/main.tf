resource "azurerm_storage_account" "eccods" {
  name                     = substr(lower(replace("${var.resource_prefix}-${var.env}-store", "/\\W*/", "")), 0, 24)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

    static_website {
    index_document = "index.html"
    error_404_document = "index.html"
  }

}


resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.container_names)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.eccods.name
  container_access_type = "blob"
}

