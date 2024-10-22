variable "location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_id" {
  type = string
}

#variable "instrumentation_key" {
#  type = string
#}


variable "default_tags" {
  type = map(any)
  default = {
    env : "test"
    source : "terraform"
  }
}

variable "env" {
  type = string
}


variable "tf_static_rg_name" {
  type = string
  
}
#variable "key_vault_id" {
#  type = string
#}

variable "managed_environment_name" {
  type = string
}

#variable "container_apps" {
#  type = list(object({
#    name                              = string
#    image                             = string
#    tag                               = string
#    secrets                           = list(string)
#    additional_secrets                = map(string)
#    health_check_path                 = optional(string, "/")
#    
#  }))
#}

variable "la_workspace_long_id" {
  type    = string
  default = ""
}

variable "capacity_default" {
  type    = number
  default = 1
}

variable "capacity_minimum" {
  type    = number
  default = 1
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "virtual_network_id" {
  type    = string
  default = null
}

variable "containerapp_names" {
  type    = list(string)
  default = ["app01acae"]
}


variable "primary_shared_key" {
  type    = string
  default = "app01acae"
}


variable "log_analytics_workspace_id" {
  type    = string
  default = "app01acae"
}


variable "la_workspace_id" {
  type    = string
  default = "app01acae"
}

   