# Azure Windows Web App Module

This module creates an Azure Windows Web App.

## Usage

```hcl
module "windows_webapp" {
  source = "git::https://github.com/your-org/terraform-azure-webapp-modules.git//modules/windows_webapp?ref=v1.0.0"

  name                = "my-windows-webapp"
  resource_group_name = "my-resource-group"
  location            = "East US"
  app_service_plan_id = azurerm_service_plan.example.id

  app_settings = {
    "ASPNETCORE_ENVIRONMENT"    = "Production"
    "WEBSITE_LOAD_CERTIFICATES" = "*"
  }
}
```

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.13.0 |
| azurerm   | >= 4.0.0  |

## Inputs

| Name                | Description                     | Type          | Default | Required |
| ------------------- | ------------------------------- | ------------- | ------- | :------: |
| name                | The name of the Windows Web App | `string`      | n/a     |   yes    |
| resource_group_name | The name of the resource group  | `string`      | n/a     |   yes    |
| location            | The Azure location              | `string`      | n/a     |   yes    |
| app_service_plan_id | The ID of the App Service Plan  | `string`      | n/a     |   yes    |
| app_settings        | App settings for the web app    | `map(string)` | `{}`    |    no    |

## Outputs

| Name      | Description                   |
| --------- | ----------------------------- |
| webapp_id | The ID of the Windows Web App |
