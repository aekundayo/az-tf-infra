

module "kv" {
   source = "../modules/key_vault"
    location                            = var.location
    resource_group_name                 = module.rg.rg_name
    key_vault_name                      = "kvlt-${var.app}-${local.env}-${var.location}"
    vm_identity                         = module.vm.vm_identity
    #purge_protection_enabled            = local.env  == "prod" ? true : false
    purge_protection_enabled            = true

}

module "kv_secrets" {
   source = "../modules/key_vault_secrets"
    location                            = var.location
    resource_group_name                 = module.rg.rg_name
    key_vault_name                      = "kvlt-${var.app}-${local.env}-${var.location}"
    key_vault_id                        = module.kv.id
    certificate_name            = "../DigitalShowroomRootCert.crt"


    keyvault_secrets = {
        redisKey                        = { value = module.redis_cache.redis_key, content_type = "redis cache key" }
        redisConnectionString           = { value = module.redis_cache.redis_connection_string, content_type = "redis cache connection string" }
        redisHostName                   = { value = module.redis_cache.redis_host_name, content_type = "redis cache host name" }
        postgresAdminUser               = { value = module.postgres.administrator_login_username, content_type = "postgres admin user" }
        postgresAdminPassword           = { value = module.postgres.administrator_login_password, content_type = "postgres admin password" }
        postgresUser                    = { value = "db_user", content_type = "postgres user" }
        showroomDB                      = { value = "ds_${local.env}", content_type = "digital showroom database name"}
        postgresPassword                = { value = module.postgres.db_usr_login_password, content_type = "postgres password" }
        postgresName                    = { value = "postgres", content_type = "postgres database name" }
        postgresHost                    = { value = module.postgres.database_host, content_type = "postgres host" }
        laWorkspacePrimarySharedKey     = { value = module.la.la_workspace_primary_shared_key, content_type = "log analytics workspace primary shared key" }
        aiInstrumentationKey            = { value = module.la.ai_instrumentation_key, content_type = "application insight instrumentation key" }
        aiConnectionString              = { value = module.la.ai_connection_string, content_type = "application insight connection string" }
        laWorkspaceId                   = { value = module.la.la_workspace_id, content_type = "log analytics workspace id" }
        laWorkspaceLongId               = { value = module.la.la_workspace_long_id, content_type = "log analytics workspace long id" }
        storageAccountKey               = { value = module.storage.key, content_type = "storage account key" }
        storageAccountName              = { value = module.storage.name, content_type = "storage account name" }
        storageAccountConnectionString  = { value = module.storage.static_connection_string, content_type = "storage account connection string" }
        userAssignedPrincipalId         = { value = module.app_gtw.user_assigned_principal_id, content_type = "user assigned principal id" }
        userAssignedId                  = { value = module.app_gtw.user_assigned_id, content_type = "user assigned id" }
        subnetId                        = { value = module.network.vnet_subnets["BackendSubnet"].id, content_type = "backend subnet id" }
        agentVMPrivateKey               = { value = module.vm.ssh_private_key, content_type = "agent vm private key" }
        agentVMPublicKey                = { value = module.vm.ssh_public_key, content_type = "agent vm public key" }
        backupFileName                  = { value = local.env=="dev"||local.env=="test"?"TestDevBackup":"ProdUatBackup", content_type = "backup file name" }
        ddEnv                           = { value = local.env, content_type = "dd env" }
        ddLogsInjection                 = { value = "true", content_type = "dd logs injection" }
        ddAppsecEnabled                 = { value = "true", content_type = "dd appsec enabled" }
        ddApiKey                        = { value = "8a15020ea05349bd841766b924b9862f" , content_type = "dd api key" }
        ddAppKey                        = { value = "09cd3ea3-a90d-45b8-9c3b-5f55987fe408", content_type = "dd app key" }
        ddServiceName                   = { value = "webds-api", content_type = "dd service name" }
        ddTags                          = { value = "service:webds-api", content_type = "dd tags" }
        ddIntakeRegion                  = { value = "eu", content_type = "dd intake region" }
        VPNRootCAKey                    = { value = module.vpn.root_key, content_type = "vpn root ca key" }
        VPNRootCACrt                    = { value = module.vpn.root_crt, content_type = "vpn root ca crt" }
        VPNClientKey                    = { value = module.vpn.client_key, content_type = "vpn client key" }
        VPNClientCrt                    = { value = module.vpn.client_crt, content_type = "vpn client crt" }
    }
}



