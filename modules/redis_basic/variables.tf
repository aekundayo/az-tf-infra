variable "env" {
  type    = string
  default = "dev"
  
}

variable "app" {
  type    = string
  default = "ds"
  
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type = string
}

variable "default_tags" {
  type = map(any)
  default = {
    env : "test"
    source : "terraform"
  }

}

  variable "subnet_id" { 
    type = string
}
 variable "virtual_network_id" {
  type = string
 }

 variable "la_workspace_id" {
  type = string
 }
   
  variable "la_workspace_long_id" {
  type = string
 }

 variable "redis_cache_name" {
  type = string
 }
   
 
   