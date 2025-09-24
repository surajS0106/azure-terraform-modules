# Function Apps Module

This module creates an Azure Linux Function App with Node.js runtime.

## Resources Created

- `azurerm_linux_function_app` - Azure Linux Function App

## Usage

```hcl
module "function_apps" {
  source = "./modules/function_apps"

  name                         = "myapp-function"
  resource_group_name          = "myapp-rg"
  location                    = "East US"
  app_service_plan_id         = module.app_service_plan.id
  storage_account_name        = module.storage_account.name
  storage_account_access_key  = module.storage_account.primary_access_key

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name                       | Description                        | Type          | Default | Required |
| -------------------------- | ---------------------------------- | ------------- | ------- | :------: |
| name                       | Name of the Function App           | `string`      | n/a     |   yes    |
| resource_group_name        | Name of the resource group         | `string`      | n/a     |   yes    |
| location                   | Azure region                       | `string`      | n/a     |   yes    |
| app_service_plan_id        | ID of the App Service Plan         | `string`      | n/a     |   yes    |
| storage_account_name       | Name of the storage account        | `string`      | n/a     |   yes    |
| storage_account_access_key | Access key for the storage account | `string`      | n/a     |   yes    |
| always_on                  | Keep the function app loaded       | `bool`        | `true`  |    no    |
| node_version               | Node.js version                    | `string`      | `"18"`  |    no    |
| app_settings               | Application settings               | `map(string)` | `{}`    |    no    |
| tags                       | Tags to apply to resources         | `map(string)` | `{}`    |    no    |

## Outputs

| Name                  | Description                               |
| --------------------- | ----------------------------------------- |
| id                    | ID of the Function App                    |
| name                  | Name of the Function App                  |
| default_hostname      | Default hostname of the Function App      |
| kind                  | Kind of the Function App                  |
| outbound_ip_addresses | Outbound IP addresses of the Function App |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |
