
provider "azurerm" {
    features {
      
    }
  alias   = "lower_subscription"
  subscription_id = var.lower_subscription_id
}
