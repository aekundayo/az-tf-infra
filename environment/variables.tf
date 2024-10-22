variable "location" {
  type    = string
  default = "westeurope"
}



variable "app" {
  type = string
  default = "ds"
}



variable "resource_prefix"{
  type = string
  default = "digitalshowroom-dev"
}


variable "LOWER_SUBSCRIPTION" {
  type = string
}

variable "STATIC_SHARE_NAME" {
  type = string
}

variable "STATIC_STORE_KEY" {
  type = string
}

variable "STATIC_STORE_NAME" {
  type = string
}

variable "ddos_protection_plan_id" {
  type = string
}

variable "script_path" {
  type = string
  default = "../scripts"
}