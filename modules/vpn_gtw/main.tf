locals {
  rootca ="RootCA"
  clientcrt = "ClientCertificate"
  cert_content = file("${var.script_path}/${local.rootca}.crt")
  #remove the begin and end cert tags from the root cert
  cleaned_certificate = replace(replace(local.cert_content, "-----BEGIN CERTIFICATE-----", ""), "-----END CERTIFICATE-----", "")

}


# Create a Public IP for the Gateway
resource "azurerm_public_ip" "ds-gateway-ip" {
  name                = "${var.name}-gw-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}




# Create VPN Gateway
resource "azurerm_virtual_network_gateway" "ds-vpn-gtw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Standard"

  ip_configuration {
    name                          = var.vnet_name
    public_ip_address_id          = azurerm_public_ip.ds-gateway-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  vpn_client_configuration {
    address_space = ["10.2.0.0/24"]

    root_certificate {
      name = "cert"
      public_cert_data = local.cleaned_certificate
    }

  }
}

