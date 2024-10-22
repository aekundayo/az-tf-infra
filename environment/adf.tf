#module "adf" {
#    source = "../modules/data_factory"
#    adf_name = "adf-${var.app}-dev-${var.location}"
#    name = "adf-${var.app}-${local.env}-${var.location}"
#    env = local.env
#    location = var.location
#    resource_group_name = module.rg.rg_name
#    static_rg_name = local.tf_static_rg_name
#    storage_account_name = module.storage.name
#    subnet_id            = module.network.vnet_subnets["AgentSubnet"].id
#    storage_container_name = "scripts"
#    default_tags = local.default_tags
#    storage_account_key = module.storage.key
#
#}