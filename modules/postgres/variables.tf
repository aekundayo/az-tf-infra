variable "location" {
  type    = string
  default = "westeurope"
}

variable "env" {
  type    = string
  default = "westeurope"
}


variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "default_tags" {
  type = map(any)
  default = {
    env : "test"
    source : "terraform"
  }
}

variable "sku_name" {
  type    = string
  default = "GP_Standard_D2s_v3"
}

variable "storage_mb" {
  type    = number
  default = 32768
}


variable "postgres_version" {
  type    = string
  default = "12"
}

variable "delegated_subnet_id" {
  type    = string
  default = ""
}

variable "vnet_id" {
  type    = string
}
  


variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "geo_redundant_backup_enabled" {
  type    = bool
  default = false
}

variable "ssl_enforcement_enabled" {
  type    = bool
  default = true
}

 variable "la_workspace_id" {
  type = string
 }
  
variable "la_workspace_long_id" {
  type = string
  default = ""
  
}