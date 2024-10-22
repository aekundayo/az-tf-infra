variable "name" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  type        = string
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space."
  type        = list(string)
}

variable "subnets" {
   type = list(object({
     name                                      = string
     address_prefix                            = string
     network_security_group_id                 = optional(string, null)
     service_endpoints                         = optional(list(object({ service = string })), [])
     delegations = optional(list(object({
       name = string
       properties = object({
         serviceName = string
         actions     = list(string)
       })
     })), [])

   }))

 }

variable "env" {
  type = string
  default = "dev"  
}
variable "default_tags" {
  type = map(any)
  default = {
    source : "terraform"
  }
}

variable "ddos_protection_plan_id" {
  type = string
  default = ""
 
}
