resource "random_string" "random" {
  length  = 10
  lower   = true
  numeric = false
  special = false
  upper   = false
}



resource "azurerm_data_factory" "adf" {
    count = var.env == "dev" ? 1 : 0
    name                = var.name
    location            = var.location
    resource_group_name   = var.static_rg_name
}

data "azurerm_data_factory" "adf" {
    provider = azurerm.dev-subscription
    name                = "adf-ds-dev-westeurope"
    resource_group_name   = var.static_rg_name
    depends_on = [ azurerm_data_factory.adf ]
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "shir_dev" {
    count = var.env == "dev" ? 1 : 0
    name                = "shir-dev-${var.name}"
    data_factory_id     = data.azurerm_data_factory.adf.id
    depends_on = [ data.azurerm_data_factory.adf ]
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "shir_test" {
    count = var.env == "dev" ? 1 : 0
    name                = "shir-test-${var.name}"
    data_factory_id     = data.azurerm_data_factory.adf.id
    depends_on = [ data.azurerm_data_factory.adf ]
}

resource "azurerm_storage_blob" "newblob" {
  name                   = "adf-shir.ps1"
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  type                   = "Block"
  access_tier            = "Cool"
  source                 = "../gatewayinstall.ps1"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.default_tags
}

resource "azurerm_windows_virtual_machine" "main" {
  name                  = "agent-vm-${var.env}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size               = "Standard_B2ms"
  admin_username = "testadmin"
  admin_password = "Password1234!"
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }
}

#resource "azurerm_virtual_machine_extension" "vmextension-0000" {
#  name                       = "ADF-SHIR"
#  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
#  publisher                  = "Microsoft.Compute"
#  type                       = "CustomScriptExtension"
#  type_handler_version       = "1.10"
#  auto_upgrade_minor_version = true
#
#  protected_settings = <<PROTECTED_SETTINGS
#      {
#          "fileUris": ["${format("https://%s.blob.core.windows.net/%s/%s", var.storage_account_name, var.storage_container_name, azurerm_storage_blob.newblob.name)}"],
#          "commandToExecute": "${join(" ", ["powershell.exe -ExecutionPolicy Unrestricted -File",azurerm_storage_blob.newblob.name,"-gatewayKey ${azurerm_data_factory_integration_runtime_self_hosted.shir.primary_authorization_key}"])}",
#          "storageAccountName": "${var.storage_account_name}",
#          "storageAccountKey": "${var.storage_account_key}"
#      }
#  PROTECTED_SETTINGS
#}