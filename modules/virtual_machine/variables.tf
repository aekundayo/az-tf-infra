variable "vm_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "env" {
  type = string
}

variable "static_store" {
  type = string
}

variable "static_key" {
  type = string
}

variable "static_fileshare" {
  type = string
}



variable "pg_action" {
  description = "The action to perform: either 'dump' or 'restore'."
  default = "dump"
  validation {
    condition     = contains(["dump", "restore"], var.pg_action)
    error_message = "The pg_action variable must be set to either 'dump' or 'restore'."
  }
}


variable "kv_name" {
  type = string
}

variable "backup_cron_schedule" {
  type = string
}


variable "restore_cron_schedule" {
  type = string
}

variable "virtual_network_id" {
  type = string  
}

variable "script_path" {
  type = string
}