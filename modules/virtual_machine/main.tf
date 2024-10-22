locals {
  ssh_name = "agent_ssh"

}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "null_resource" "ssh_keygen" {
  provisioner "local-exec" {
    #command = "./ssh_keygen.sh ${local.ssh_path} ${local.ssh_name}" # Assuming the script is in the same directory
    command = "echo SSH Key gen now executed in github action"
  }

}

 
resource "azurerm_linux_virtual_machine" "agent_vm" {
  #count = var.env == "prod" || var.env == "test" ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${var.script_path}/${local.ssh_name}.pub")
  }


  disable_password_authentication = true
  depends_on = [ azurerm_network_interface.nic, null_resource.ssh_keygen ]
}


# -
# - Custom Scripts
# -
data "local_file" "sh" {
  filename = "${var.script_path}/vm_script.sh"
}


resource "azurerm_virtual_machine_extension" "agent_pg_extension" {
  name                 = "vm_db_backup_extension"
  virtual_machine_id   = azurerm_linux_virtual_machine.agent_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  

  protected_settings = jsonencode({
    "commandToExecute": "export RESTORE_SCHEDULE='${var.restore_cron_schedule}' && export BACKUP_SCHEDULE='${var.backup_cron_schedule}' && export PG_ACTION=${var.pg_action} && export KV_NAME=${var.kv_name}  && export ENV=${var.env} && ./${data.local_file.sh.content}|| true"
  })


}