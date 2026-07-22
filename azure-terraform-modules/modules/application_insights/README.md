# Application Insights Module

This module creates an Azure Application Insights resource for application performance monitoring.

## Resources Created

- `azurerm_application_insights` - Azure Application Insights

## Usage

```hcl
module "application_insights" {
  source = "./modules/application_insights"

  name                = "myapp-insights"
  resource_group_name = "myapp-rg"
  location           = "East US"
  workspace_id       = module.log_analytics_workspace.id

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name                | Description                       | Type          | Default | Required |
| ------------------- | --------------------------------- | ------------- | ------- | :------: |
| name                | Name of the Application Insights  | `string`      | n/a     |   yes    |
| resource_group_name | Name of the resource group        | `string`      | n/a     |   yes    |
| location            | Azure region                      | `string`      | n/a     |   yes    |
| workspace_id        | ID of the Log Analytics Workspace | `string`      | `null`  |    no    |
| application_type    | Type of application               | `string`      | `"web"` |    no    |
| retention_in_days   | Data retention in days            | `number`      | `90`    |    no    |
| tags                | Tags to apply to resources        | `map(string)` | `{}`    |    no    |

## Outputs

| Name                | Description                      |
| ------------------- | -------------------------------- |
| id                  | ID of the Application Insights   |
| name                | Name of the Application Insights |
| instrumentation_key | Instrumentation key              |
| connection_string   | Connection string                |
| app_id              | Application ID                   |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |

## Notes

- When workspace_id is provided, Application Insights will use workspace-based mode
- Default application type is "web" suitable for web applications
