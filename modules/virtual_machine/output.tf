output "ssh_private_key" {
  value = file("${var.script_path}/${local.ssh_name}")
}
  
output "ssh_public_key" {
  value = file("${var.script_path}/${local.ssh_name}.pub")
}

output "vm_identity" {
  value = "${azurerm_linux_virtual_machine.agent_vm.identity.0.principal_id}"
  
}