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
