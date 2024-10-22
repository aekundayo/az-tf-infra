

 

resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "standard"

  tenant_id  = data.azurerm_subscription.current.tenant_id
  enabled_for_disk_encryption = true
  purge_protection_enabled = var.purge_protection_enabled

}

resource "azurerm_key_vault_access_policy" "kvap" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = "5db3f683-b1f6-4719-a4f1-4f57c0ee9810"

  key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge",
      "Release"
  ]

  certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover",
    "Backup",
    "Restore"
  ]
}


resource "azurerm_key_vault_access_policy" "kvap-aek" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = "f851554b-c60d-4dd8-ab83-b57f030804bc"

  key_permissions = [
    "Get", 
    "List", 
    "Update", 
    "Create"
  ]

  certificate_permissions = [
    "Get", 
    "List", 
    "Update", 
    "Create", 
    "Import"
  ]

  secret_permissions = [
    "Get", 
    "List", 
    "Set"
  ]
}


resource "azurerm_key_vault_access_policy" "vm_kv_acess" {
  key_vault_id = azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_subscription.current.tenant_id
  object_id = var.vm_identity

  secret_permissions = [
    "Get", 
    "List", 
    "Set"
  ]
}

