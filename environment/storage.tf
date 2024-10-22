

module "postgres" {
 source = "../modules/postgres"
  name   = "postgres-${var.app}-${local.env}-${var.location}"
  env                       = local.env
  location                  = var.location
  resource_group_name       = module.rg.rg_name
  delegated_subnet_id       = module.network.vnet_subnets["DataSubnet"].id
  vnet_id                   = module.subnet_patching.vnet_id
  storage_mb                = local.env  == "prod" || local.env == "uat" ? 4194304 : 32768
  sku_name                  = local.env  == "prod" || local.env == "uat" ? "GP_Standard_D4s_v3" : "GP_Standard_D2s_v3"
  postgres_version          = "14"
  la_workspace_id = module.la.la_workspace_id
  la_workspace_long_id= module.la.la_workspace_long_id
  backup_retention_days     = 30
  depends_on = [
    module.network
  ]
}

module "storage" {
 source               = "../modules/storage"
  env                 = local.env
  location            = var.location
  resource_group_name = module.rg.rg_name
  container_names = ["assets", "cache","scripts"]
  resource_prefix     = var.resource_prefix
  subnet_ids = [ module.network.vnet_subnets["DataSubnet"].id, module.network.vnet_subnets["RedisSubnet"].id,module.network.vnet_subnets["AgentSubnet"].id,module.network.vnet_subnets["DataSubnet"].id, module.network.vnet_subnets["ApplicationGatewaySubnet"].id]
}

module "redis_cache" {
 source = "../modules/redis_basic"
  location            = var.location
  env                 = local.env
  app                 = var.app
  redis_cache_name    = "redis-${var.app}-${local.env}-${var.location}"
  subnet_id           = module.network.vnet_subnets["RedisSubnet"].id
  resource_group_name = module.rg.rg_name
  virtual_network_id  = module.subnet_patching.vnet_id
  la_workspace_id = module.la.la_workspace_id
  la_workspace_long_id= module.la.la_workspace_long_id
  depends_on = [
    module.network
  ]

}