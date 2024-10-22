variable "name" {
  description = "The name of the Application Gateway. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  type        = string
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "westeurope"
}


variable "sku" {
  description = "The details of the SKU to use for this Application Gateway."
  type = object({
    name = optional(string, "WAF_v2")
    tier = optional(string, "WAF_v2")
  })
  default = {
    name = "WAF_v2"
    tier = "WAF_v2"
  }
}

variable "autoscale_configuration" {
  type = object({
    min_capacity = optional(number, 1)
    max_capacity = optional(number, 2)
  })
  default = {
    min_capacity = 1
    max_capacity = 2
  }
}

variable "enable_http2" {
  type    = bool
  default = false
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet which the Application Gateway should be connected to."
}



variable "la_workspace_id" {
  type = string
}

variable "la_workspace_long_id" {
  type    = string
  default = ""
}


variable "tf_static_rg_name" {
  type = string
}

variable "vault_id" {
  type = string
}

variable "user_identity_name" {
  type = string
}

variable "env" {
  type = string
}

variable "backend_targets" {
  type = list(object({
    name          = string
    a_record_name = string
    fqdns         = list(string)
    port          = optional(number, 443)
    request_timeout = optional(number, 180)
    protocol      = optional(string, "Https")
    health_path   = optional(string, "/about")
    key_vault_cert_name = string
    path_name = string
    path=list(string)
    rewrite_pattern=string

  }))
}

variable "rewrite_rules" {
  type = list(object({
    name          = string
    path_name = string
    path=list(string)
    rewrite_pattern=string

  }))
}

variable "policy_enabled" {
  type = bool
  default = true
}