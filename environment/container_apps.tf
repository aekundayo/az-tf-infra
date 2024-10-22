

module "ca" {
 source = "../modules/container_apps"

    location                  = var.location
    env                       = local.env
    #managed_environment_name  = local.env == "dev" ? "caeint-${var.app}-${local.env}-${var.location}" : "cae-${var.app}-${local.env}-${var.location}"
    managed_environment_name  = "caenv-${var.app}-${local.env}-${var.location}"
    tf_static_rg_name         = local.tf_static_rg_name
    resource_group_name       = module.rg.rg_name
    resource_group_id         = module.rg.rg_id
    #prod container app refuses to deploy if the subnet is "BackendSubnet" becasue there is a lingering container on that subnet
    subnet_id                 = module.network.vnet_subnets["BackendSubnet"].id
    #subnet_id                 = local.env == "prod" ? module.network.vnet_subnets["BackupBackendSubnet"].id : module.network.vnet_subnets["BackendSubnet"].id
    virtual_network_id        = module.subnet_patching.vnet_id
    containerapp_names         = ["web-${var.app}-${local.env}-${var.location}","api-${var.app}-${local.env}-${var.location}","assets-${var.app}-${local.env}-${var.location}"]
    primary_shared_key        = module.la.la_workspace_primary_shared_key
    la_workspace_long_id      = module.la.la_workspace_long_id
    la_workspace_id           = module.la.la_workspace_id
    depends_on = [module.subnet_patching]


}

module "app_gtw" {
   source = "../modules/application_gateway"

    name                     = "agw-${var.app}-${local.env}-${var.location}"
    location                 = var.location
    env                      = local.env
    resource_group_name      = module.rg.rg_name
    subnet_id                = module.network.vnet_subnets["ApplicationGatewaySubnet"].id
    la_workspace_id          = module.la.la_workspace_id
    la_workspace_long_id     = module.la.la_workspace_long_id
    tf_static_rg_name        = local.tf_static_rg_name
    vault_id                 = module.kv.id
    user_identity_name       = "agw-id-${local.env}-${var.location}"
    policy_enabled = local.env == "dev" || local.env == "uat" ? false : true
    backend_targets = [
        {
        name          = "web"
        a_record_name = local.env == "prod" ? "${local.zone_name}" : "${local.env}.${local.zone_name}"
        health_path  = "/"
        fqdns         = [replace(replace(module.cdn.cdn_endpoint, "https://", ""),"/", "")] #[] # todo derive webapp-hw-dro-dev
        key_vault_cert_name = "${local.env}-web-cert"
        path_name="default"
        path=["/*"]
        rewrite_pattern="/"
        },
         {
        name          = "assets"
        a_record_name = local.env == "prod" ? "assets.${local.zone_name}" : "${local.env}-api.${local.zone_name}"
        health_path  = "/health-check"
        fqdns         = [module.ca.fqdn_assets] #[] # todo derive webapp-hw-dro-dev
        key_vault_cert_name = "${local.env}-api-cert"
        path_name="assets"
        path=["/api/assets/*"]›
        rewrite_pattern="api/assets"
        },
         {
        name          = "api"
        a_record_name = local.env == "prod" ? "api.${local.zone_name}" : "${local.env}-api.${local.zone_name}"
        health_path  = "/health-check"
        fqdns         = [module.ca.fqdn_api] #[] # todo derive webapp-hw-dro-dev
        key_vault_cert_name = "${local.env}-api-cert"
        path_name="api"
        path=["/api/*"]›
        rewrite_pattern="api"
        },      
        {
        name          = "socket.io"
        a_record_name = local.env == "prod" ? "api.${local.zone_name}" : "${local.env}-api.${local.zone_name}"
        health_path  = "/health-check"
        fqdns         = [module.ca.fqdn_api] #[] # todo derive webapp-hw-dro-dev
        key_vault_cert_name = "${local.env}-api-cert"
        path_name="socket.io"
        path=["/socket.io/*"]
        rewrite_pattern="api"
        }
   
    ]

    rewrite_rules = [
 
         {
        name        = "api"
        path_name   ="api"
        path        =["/api/*"]
        rewrite_pattern="api"
        }
   
    ]

         


}
  
