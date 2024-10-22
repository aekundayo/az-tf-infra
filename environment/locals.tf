locals {
  subscription_id                 = "77a56e73-484b-428e-b0be-f0e8b64ffc50"
  environment                     = terraform.workspace
  ecco_user_id                    = "aek"
  tf_static_rg_name               = "rg-DigitalShowroom-static-westeurope-001"
  tf_mgmt_rg_name                 = "rg-mgmt-dev-westeurope-001"
  tf_mgmt_key_vault_name          = "kv-${var.app}-${local.env}-westeurope"
  tf_mgmt_key_vault_id            = "/subscriptions/${local.subscription_id}/resourceGroups/rg-mgmt-dev-westeurope-001/providers/Microsoft.KeyVault/vaults/${local.tf_mgmt_key_vault_name}"
  resource_group_name             = "rg-DigitalShowroom-${terraform.workspace}-westeurope-001"
  env                             = terraform.workspace
  vnet_address_space_0              = ["10.0.0.0/20"]
  gateway_subnet_address_prefix_0   = "10.0.0.0/24"
  #container apps require a subnet with at least a /23 mask
  backend_subnet_address_prefix_0   = "10.0.2.0/23"
  database_subnet_address_prefix_0  = "10.0.4.0/24"
  redis_subnet_address_prefix_0     = "10.0.5.0/24"
  vpn_subnet_address_prefix_0       = "10.0.6.0/24"
  bu_backend_subnet_address_prefix_0 = "10.0.8.0/23"
  agent_subnet_address_prefix_0     = "10.0.10.0/24"

  vnet_address_space_1              = ["10.1.0.0/20"]
  gateway_subnet_address_prefix_1   = "10.1.0.0/24"
  #container apps require a subnet with at least a /23 mask
  backend_subnet_address_prefix_1   = "10.1.2.0/23"
  database_subnet_address_prefix_1  = "10.1.4.0/24"
  redis_subnet_address_prefix_1     = "10.1.5.0/24"
  vpn_subnet_address_prefix_1       = "10.1.6.0/24"
  bu_backend_subnet_address_prefix_1 = "10.1.8.0/23"
  agent_subnet_address_prefix_1     = "10.1.10.0/24"

  zone_name                       = "showroom.ecco.com"
  db_zone_name                    = "showroom.ecco.com"
  default_tags = {
    env    = local.env
    source = "terraform"
  }
}