variable "location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type = string
}
variable "env" {
  type = string
}

variable "default_tags" {
  type = map(any)
  default = {
    env : "test"
    source : "terraform"
  }
}

variable "resource_prefix" {
  type = string
}

variable "container_names" {
  description = "Names of the storage containers"
  type        = list(string)
  default     = ["assets", "cache","scripts"]
}

variable "subnet_ids" {
  description = "Subnet IDs to allow access to the storage account"
  type        = list(string)
  default     = []
  
}