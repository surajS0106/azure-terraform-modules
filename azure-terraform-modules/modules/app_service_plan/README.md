# App Service Plan Module

This module creates an Azure App Service Plan for hosting web apps and function apps.

## Resources Created

- `azurerm_service_plan` - Azure App Service Plan

## Usage

```hcl
module "app_service_plan" {
  source = "./modules/app_service_plan"

  name                = "myapp-plan"
  resource_group_name = "myapp-rg"
  location           = "East US"
  os_type            = "Linux"
  sku_name           = "S1"

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name                | Description                              | Type          | Default | Required |
| ------------------- | ---------------------------------------- | ------------- | ------- | :------: |
| name                | Name of the App Service Plan             | `string`      | n/a     |   yes    |
| resource_group_name | Name of the resource group               | `string`      | n/a     |   yes    |
| location            | Azure region                             | `string`      | n/a     |   yes    |
| os_type             | Operating system type (Linux or Windows) | `string`      | n/a     |   yes    |
| sku_name            | SKU name for the App Service Plan        | `string`      | n/a     |   yes    |
| worker_count        | Number of workers                        | `number`      | `null`  |    no    |
| tags                | Tags to apply to resources               | `map(string)` | `{}`    |    no    |

## Outputs

| Name     | Description                              |
| -------- | ---------------------------------------- |
| id       | ID of the App Service Plan               |
| name     | Name of the App Service Plan             |
| kind     | Kind of the App Service Plan             |
| reserved | Whether the App Service Plan is reserved |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |

## SKU Examples

| SKU        | Description | Tier     |
| ---------- | ----------- | -------- |
| F1         | Free        | Free     |
| D1         | Shared      | Shared   |
| B1, B2, B3 | Basic       | Basic    |
| S1, S2, S3 | Standard    | Standard |
| P1, P2, P3 | Premium     | Premium  |

## Notes

- os_type must be either "Linux" or "Windows"
- SKU determines the pricing tier and capabilities
- worker_count is optional and will use default scaling if not specified
