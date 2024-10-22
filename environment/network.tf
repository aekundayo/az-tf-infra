


module "gtw_nsg" {
 source = "../modules/network_security_group"

  name                = "nsg-${var.app}-gateway-${local.env}-${var.location}"
  location            = var.location
  resource_group_name = module.rg.rg_name
  security_rules = [
    {
      name                   = "AllowHTTP"
      description            = "allow http"
      destination_port_range = "80"
      access                 = "Allow"
      priority               = 100
      direction              = "Inbound"
    },
    {
      name                   = "AllowHTTPS"
      description            = "allow https"
      destination_port_range = "443"
      access                 = "Allow"
      priority               = 101
      direction              = "Inbound"
    },
    {
      name                   = "AllowAzureInfrastructure"
      description            = "allow Azure infrastructure communication"
      source_address_prefix  = "*"
      destination_port_range = "65200-65535"
      access                 = "Allow"
      priority               = 4000
      direction              = "Inbound"
    },
    {
      name                  = "AllowAzureLoadBalancer"
      description           = "allow azure load balancer communication"
      source_address_prefix = "AzureLoadBalancer"
      access                = "Allow"
      priority              = 4001
      direction             = "Inbound"
    }
  ]
}




module "be_nsg" {
  source              = "../modules/network_security_group"
  name                = "nsg-${var.app}-backend-${local.env}-${var.location}"
  location            = var.location
  resource_group_name = module.rg.rg_name
  security_rules = [

    {
      name                       = "AllowAnyCustomAnyInbound"
      description                = "Allow communication between IPs in the infrastructure subnet. This address is passed as a parameter when you create an environment."
      priority                   = 100
      direction                  = "Inbound"
      source_address_prefix      = "10.0.0.0/20"
      destination_address_prefix = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      protocol                   = "Tcp"
      access                     = "Allow"
    },
    {
      name                       = "AllowGatewaySubnetInbound8080"
      description                = "	Allow the Azure infrastructure load balancer to communicate with your environment."
      protocol                   = "Tcp"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      access                     = "Allow"
      priority                   = 103
      direction                  = "Inbound"
    },
    {
      name                       = "AllowTagCustom1194Outbound"
      description                = "	Required for internal AKS secure connection between underlying nodes and control plane."
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "1194"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud.westeurope"
      access                     = "Allow"
      priority                   = 104
      direction                  = "Outbound"

    },
    {
      name                       = "AllowTagCustom9000Outbound"
      description                = "	Required for internal AKS secure connection between underlying nodes and control plane."
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9000"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud.westeurope"
      access                     = "Allow"
      priority                   = 105
      direction                  = "Outbound"


      }, {
      name                       = "AllowTagCustom443Outbound"
      description                = "Allows outbound calls to Azure Monitor."
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureMonitor"
      access                     = "Allow"
      priority                   = 106
      direction                  = "Outbound"
    },
    {
      name                       = "AllowAnyHTTPSOutbound"
      description                = "Allowing all outbound on port * (443) provides a way to allow all FQDN based outbound dependencies that don't have a static IP."
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                     = "Allow"
      priority                   = 107
      direction                  = "Outbound"


    },
    {
      name                       = "AllowAnyCustom123Outbound"
      description                = "NTP server."
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "123"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                     = "Allow"
      priority                   = 160
      direction                  = "Outbound"

    },
    {
      name                       = "AllowAnyCustom5671Outbound"
      description                = "Container Apps control plane."
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5671"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                     = "Allow"
      priority                   = 170
      direction                  = "Outbound"
    },
    {
      name                       = "AllowAnyCustomAnyOutbound"
      description                = "Allow communication between IPs in the infrastructure subnet. This address is passed as a parameter when you create an environment."
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.1.6.0/23"
      access                     = "Allow"
      priority                   = 180
      direction                  = "Outbound"
    },
    {
      name                       = "AllowAnyCustom5672Outbound"
      description                = "Container Apps control plane."
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5672"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                     = "Allow"
      priority                   = 190
      direction                  = "Outbound"

    }
  ]
}

module "network" {
 source = "../modules/virtual_network"

  name                = "vnet-${var.app}-${local.env}-${var.location}"
  location            = var.location
  resource_group_name = module.rg.rg_name
  address_space       = local.vnet_address_space_0
  ddos_protection_plan_id = var.ddos_protection_plan_id
  env = local.env

  subnets = [
    {
      name                      = "ApplicationGatewaySubnet"
      address_prefix            = local.gateway_subnet_address_prefix_0
      network_security_group_id = module.gtw_nsg.nsg_id   
      },
    {
      name                      = "BackendSubnet"
      address_prefix            = local.backend_subnet_address_prefix_0
      network_security_group_id = module.be_nsg.nsg_id

    },
    {
      name                      = "BackupBackendSubnet"
      address_prefix            = local.bu_backend_subnet_address_prefix_0
      network_security_group_id = module.be_nsg.nsg_id

    },
    {
      name                      = "DataSubnet"
      address_prefix            = local.database_subnet_address_prefix_0
      network_security_group_id = module.be_nsg.nsg_id

    },
    {
      name                      = "RedisSubnet"
      address_prefix            = local.redis_subnet_address_prefix_0
      network_security_group_id = module.be_nsg.nsg_id    
    },
    {
      name                      = "GatewaySubnet"
      address_prefix            = local.vpn_subnet_address_prefix_0
    },
    {
      name                      = "AgentSubnet"
      address_prefix            = local.agent_subnet_address_prefix_0
      network_security_group_id = module.gtw_nsg.nsg_id    
    }
  ]
  default_tags = {
    env    = local.env
    source = "terraform"
  }
}

module "subnet_patching" {
  source = "../modules/subnet_patching"

   vnet_id = module.network.vnet_id
   vnet_integration_subnet_name = "BackendSubnet"
   vnet_integration_bu_subnet_name = "BackupBackendSubnet"
   postgres_db_subnet_name = "DataSubnet"
   vnet_integration_agent_subnet_name = "AgentSubnet"
   depends_on = [ module.network ]
}

module "ntw_association" {
  source = "../modules/nat_gtw_association"
  name = "nat-${var.app}-${local.env}-${var.location}"
  location            = var.location
  resource_group_name = module.rg.rg_name
  subnet_ids = [module.network.vnet_subnets["BackupBackendSubnet"].id,module.network.vnet_subnets["BackendSubnet"].id,module.network.vnet_subnets["DataSubnet"].id,module.network.vnet_subnets["AgentSubnet"].id]
   depends_on = [ module.subnet_patching ]
}

module "vpn" {
 source = "../modules/vpn_gtw"
    name                        = "vpn-${var.app}-${local.env}-${var.location}"
    location                    = var.location
    env                         = local.env
    resource_group_name         = module.rg.rg_name
    subnet_id                   = module.network.vnet_subnets["GatewaySubnet"].id
    vnet_name                   = module.network.vnet_name
    key_vault_id                = module.kv.id
    zone_name                   = local.zone_name
    script_path = var.script_path


    depends_on = [ module.ntw_association ]


}
