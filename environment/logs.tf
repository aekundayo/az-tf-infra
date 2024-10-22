
module "la" {
 source = "../modules/log_analytics"

  location            = var.location
  env                 = local.env
  resource_group_name = module.rg.rg_name
  la_name = "la-${var.app}-${local.env}-${var.location}"
  ai_name = "ai-${var.app}-${local.env}-${var.location}"
}