module "vm" {
source = "../modules/virtual_machine"
  location            = var.location
  resource_group_name = local.resource_group_name
  subnet_id = module.network.vnet_subnets["AgentSubnet"].id
  nic_name = "nic-vm-${var.app}-${local.env}-${var.location}"
  vm_name = "vm-${var.app}-${local.env}-${var.location}"
  static_fileshare = var.STATIC_SHARE_NAME
  static_store = var.STATIC_STORE_NAME
  static_key = var.STATIC_STORE_KEY
  env = local.env
  pg_action=local.env=="dev"||local.env=="uat"?"restore":"dump"
  kv_name = module.kv.name
  backup_cron_schedule = "0 0 * * 6"
  restore_cron_schedule = "0 0 * * 0"
  virtual_network_id = module.network.vnet_id
  script_path = var.script_path
}