module "rg" {
 source = "../modules/resource_group"

  location            = var.location
  resource_group_name = local.resource_group_name
  env                 = local.env
  default_tags = {
    env    = local.env
    source = "terraform"
  }
}




