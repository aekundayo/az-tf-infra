# resource group - start

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = (merge(tomap({
    "ChangeApprover"  = "PHAR"
    "LiftAndShift"    = "No"
    "application"     = "ECommerce"
    "automation"      = "Manual created"
    "businessimpact"  = "High"
    "businessprocess" = "ECommerce"
    "confidentiality" = "Confidential"
    "costcenter"      = "-108000060"
    "department"      = "IT Digital & Commerce Tech"
    "environment"     = var.env
    "optimization"    = "0x7"
    "pipeline"        = "None"
    "responsible"     = "PHAR,AKRO"
    "stakeholders"    = "PHAR,AKRO"
    "tier"            = "IT"
  }), var.default_tags)) # Additional tags set up by `Ecco Cloud Platform`
}
