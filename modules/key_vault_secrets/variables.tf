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

variable "key_vault_id" {
  type    = string
  default = "my-key-vault-id"
}

variable "keyvault_secrets" {
   type = map(object({
    value        = string
    content_type = string
  }))

}

variable "certificate_name" {
  type = string
}