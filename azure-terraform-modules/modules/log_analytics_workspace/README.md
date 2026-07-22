# Log Analytics Workspace Module

This module creates an Azure Log Analytics Workspace for centralized logging and monitoring.

## Resources Created

- `azurerm_log_analytics_workspace` - Azure Log Analytics Workspace

## Usage

```hcl
module "log_analytics_workspace" {
  source = "./modules/log_analytics_workspace"

  name                = "myapp-logs"
  resource_group_name = "myapp-rg"
  location           = "East US"
  retention_in_days  = 30

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name                | Description                         | Type          | Default       | Required |
| ------------------- | ----------------------------------- | ------------- | ------------- | :------: |
| name                | Name of the Log Analytics Workspace | `string`      | n/a           |   yes    |
| resource_group_name | Name of the resource group          | `string`      | n/a           |   yes    |
| location            | Azure region                        | `string`      | n/a           |   yes    |
| sku                 | SKU for the Log Analytics Workspace | `string`      | `"PerGB2018"` |    no    |
| retention_in_days   | Data retention in days              | `number`      | `30`          |    no    |
| daily_quota_gb      | Daily ingestion quota in GB         | `number`      | `null`        |    no    |
| tags                | Tags to apply to resources          | `map(string)` | `{}`          |    no    |

## Outputs

| Name                 | Description                         |
| -------------------- | ----------------------------------- |
| id                   | ID of the Log Analytics Workspace   |
| name                 | Name of the Log Analytics Workspace |
| workspace_id         | Workspace ID (GUID)                 |
| primary_shared_key   | Primary shared key                  |
| secondary_shared_key | Secondary shared key                |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |

## SKU Options

| SKU        | Description                        |
| ---------- | ---------------------------------- |
| Free       | 500 MB/day limit, 7 days retention |
| Standalone | Pay-as-you-go pricing              |
| PerNode    | Per-node pricing (legacy)          |
| PerGB2018  | Pay-per-GB ingested (recommended)  |

## Retention Limits

- Free tier: 7 days (fixed)
- Paid tiers: 30-730 days

## Notes

- PerGB2018 is the recommended SKU for most use cases
- Daily quota helps control costs by limiting data ingestion
- Workspace ID is used for connecting other Azure services
