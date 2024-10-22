

resource "azapi_update_resource" "postgres_db_subnet_patching" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = var.postgres_db_subnet_name
  parent_id = var.vnet_id

  body = jsonencode({
    properties = {
      privateEndpointNetworkPolicies = "Enabled"
      serviceEndpoints = [
        {
          service = "Microsoft.Storage"
        }
      ]
      delegations = [
        {
          name = "flexibleServers"
          properties = {
            serviceName = "Microsoft.DBforPostgreSQL/flexibleServers"
            actions     = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }
      ]
    }
  })
    

}

resource "azapi_update_resource" "backend_subnet_patching" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = var.vnet_integration_subnet_name
  parent_id = var.vnet_id

  body = jsonencode({
    properties = {
      serviceEndpoints = [
        {
          service = "Microsoft.Storage"
        }
      ]
      
      delegations = [
        {
          name = "serverFarms"
          properties = {
            serviceName = "Microsoft.App/environments"
            actions     = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }
      ]
    }
  })
  depends_on = [
    azapi_update_resource.postgres_db_subnet_patching
  ]

  

}

resource "azapi_update_resource" "bu_backend_subnet_patching" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = var.vnet_integration_bu_subnet_name
  parent_id = var.vnet_id

  body = jsonencode({
    properties = {
      serviceEndpoints = [
        {
          service = "Microsoft.Storage"
        }
      ]
      delegations = [
        {
          name = "serverFarms"
          properties = {
            serviceName = "Microsoft.App/environments"
            actions     = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }
      ]
    }
  })
  depends_on = [
    azapi_update_resource.backend_subnet_patching
  ]

  

}

resource "azapi_update_resource" "agent_backend_subnet_patching" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = var.vnet_integration_agent_subnet_name
  parent_id = var.vnet_id

  body = jsonencode({
    properties = {
      serviceEndpoints = [
        {
          service = "Microsoft.Storage"
        }
      ]
      
    }
  })
  depends_on = [
    azapi_update_resource.bu_backend_subnet_patching
  ]

  

}

