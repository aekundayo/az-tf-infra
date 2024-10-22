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


variable "resource_prefix" {
  type = string
}

variable "static_website_endpoint" {
  type = string
  
}

variable "origin_header" {
  type = string
  
}
