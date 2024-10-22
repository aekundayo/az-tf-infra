module "cdn" {
 source = "../modules/cdn"

    location                  = var.location
    env                       = local.env
    resource_group_name       = module.rg.rg_name
    static_website_endpoint   = replace(replace(module.storage.static_website_endpoint, "https://", ""),"/", "") 
    resource_prefix           = var.resource_prefix
    origin_header             = local.env == "prod" ? "${local.zone_name}" : "${local.env}.${local.zone_name}"
}