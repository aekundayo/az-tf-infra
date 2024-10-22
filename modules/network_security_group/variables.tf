variable "name" {
  description = "The name of the subnet. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  type        = string
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the Subnet to associate with this resource."
  type        = string
  default     = null
}

variable "security_rules" {
  description = "List of objects representing security rules."
  type = list(object({
    name                                       = string
    description                                = string
    protocol                                   = optional(string, "Tcp")
    source_port_range                          = optional(string, "*")
    destination_port_range                     = optional(string, "*")
    source_address_prefix                      = optional(string, "*")
    source_application_security_group_ids      = optional(list(string))
    destination_address_prefix                 = optional(string, "*")
    destination_application_security_group_ids = optional(list(string))
    access                                     = string
    priority                                   = number
    direction                                  = string
  }))
}
