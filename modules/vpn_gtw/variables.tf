variable "location" {
  type    = string
  default = "westeurope"
}
variable "name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "env" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "zone_name" {
  type = string
  
}

variable "script_path" {
  type = string
}