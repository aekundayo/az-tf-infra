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

variable "subnet_ids" {
   type = list(string)
   default     = []
}

variable "default_tags" {
  type = map(any)
  default = {
    source : "terraform"
  }
}


