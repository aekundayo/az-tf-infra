locals {
  lower_env = local.env == "test" ? "dev" : "uat"
  
}

module "peering" {
    source= "../modules/vnet_peering"

    

    resource_group_name = module.rg.rg_name
    vnet_name = module.network.vnet_name
    vnet_id = module.subnet_patching.vnet_id
    lower_vnet_name = "vnet-${var.app}-${local.lower_env}-${var.location}"
    lower_vnet_rg_name = "rg-DigitalShowroom-${local.lower_env}-westeurope-001"
    #lower_subscription_id = var.LOWER_SUBSCRIPTION
    peering1to2_name = "peering1to2-${var.app}-${local.env}-${var.location}"
    peering2to1_name = "peering2to1-${var.app}-${local.env}-${var.location}"
    execution_count = local.env == "prod" || local.env == "test" ? 0 : 0


}