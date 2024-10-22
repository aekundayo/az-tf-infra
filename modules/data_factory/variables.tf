variable "location" {
  type    = string
  default = "westeurope"
}
variable "name" {
    type = string
}

variable "adf_name" {
    type = string
}

variable "resource_group_name" {
  type = string
}

variable "static_rg_name" {
  type = string
}

variable "env" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "subnet_id" {
    type = string
}

variable "default_tags" {
  type = map(any)
  default = {
    env : "test"
    source : "terraform"
  }
}

variable "storage_account_key" {
  type = string
  
}