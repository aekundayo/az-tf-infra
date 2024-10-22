terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.59.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "1.6.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
    commercetools = {
      source = "labd/commercetools"
      version = "1.6.9"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  
}

provider "azurerm" {
  features {}
  alias             = "dev_subscription"
  subscription_id   = "47fd1593-e0b8-46d8-a4fd-bd2e95cbe737"
  
}

provider "azapi" {
        #subscription_id = "${local.subscription_id}"
}

provider "random" {}


