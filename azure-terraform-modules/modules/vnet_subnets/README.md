# Virtual Network and Subnets Module

This module creates an Azure Virtual Network with configurable subnets.

## Resources Created

- `azurerm_virtual_network` - Azure Virtual Network
- `azurerm_subnet` - Azure Subnets (dynamic based on configuration)

## Usage

```hcl
module "vnet_subnets" {
  source = "./modules/vnet_subnets"

  vnet_name           = "myapp-vnet"
  resource_group_name = "myapp-rg"
  location           = "East US"
  address_space      = ["10.0.0.0/16"]

  subnets = {
    "web" = {
      address_prefixes = ["10.0.1.0/24"]
      delegations = []
    }
    "api" = {
      address_prefixes = ["10.0.2.0/24"]
      delegations = []
    }
    "database" = {
      address_prefixes = ["10.0.3.0/24"]
      delegations = []
    }
  }

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Usage with App Service Integration

```hcl
module "vnet_subnets" {
  source = "./modules/vnet_subnets"

  vnet_name           = "myapp-vnet"
  resource_group_name = "myapp-rg"
  location           = "East US"
  address_space      = ["10.0.0.0/16"]

  subnets = {
    "webapp" = {
      address_prefixes = ["10.0.1.0/24"]
      delegations = [{
        name = "webapp-delegation"
        service_delegation = {
          name = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }]
    }
  }

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name                | Description                           | Type           | Default | Required |
| ------------------- | ------------------------------------- | -------------- | ------- | :------: |
| vnet_name           | Name of the Virtual Network           | `string`       | n/a     |   yes    |
| resource_group_name | Name of the resource group            | `string`       | n/a     |   yes    |
| location            | Azure region                          | `string`       | n/a     |   yes    |
| address_space       | Address space for the Virtual Network | `list(string)` | n/a     |   yes    |
| subnets             | Map of subnet configurations          | `map(object)`  | n/a     |   yes    |
| tags                | Tags to apply to resources            | `map(string)`  | `{}`    |    no    |

## Subnet Configuration

Each subnet in the `subnets` map should have the following structure:

```hcl
subnet_name = {
  address_prefixes = ["10.0.1.0/24"]  # List of address prefixes
  delegations = [                      # Optional list of delegations
    {
      name = "delegation-name"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"  # Service to delegate to
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  ]
}
```

## Outputs

| Name         | Description                             |
| ------------ | --------------------------------------- |
| vnet_id      | ID of the Virtual Network               |
| vnet_name    | Name of the Virtual Network             |
| subnet_ids   | Map of subnet names to their IDs        |
| subnet_names | Map of subnet names to their full names |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |

## Common Delegations

| Service                  | Delegation Name                             | Actions                                                                                                                                                                                                   |
| ------------------------ | ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| App Service              | Microsoft.Web/serverFarms                   | Microsoft.Network/virtualNetworks/subnets/action                                                                                                                                                          |
| SQL Managed Instance     | Microsoft.Sql/managedInstances              | Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action |
| Azure Container Instance | Microsoft.ContainerInstance/containerGroups | Microsoft.Network/virtualNetworks/subnets/action                                                                                                                                                          |

## Notes

- Address spaces and subnet prefixes must not overlap
- Delegations are optional and used for service integration
- Subnet names will be prefixed with the VNet name automatically
