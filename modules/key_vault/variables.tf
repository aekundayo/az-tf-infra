variable "location" {
  type    = string
  default = "westus2"
}

variable "resource_group_name" {
  type    = string
  default = "my-resource-group"
}

variable "key_vault_name" {
  type    = string
  default = "my-key-vault"
}

variable "purge_protection_enabled" {
  type    = bool
  default = true
}

variable "vm_identity" {
  type    = string
  default = "SystemAssigned"
  
}
