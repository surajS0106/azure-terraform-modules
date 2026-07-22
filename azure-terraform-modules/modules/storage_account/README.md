# Storage Account Module

This module creates an Azure Storage Account with configurable settings.

## Resources Created

- `azurerm_storage_account` - Azure Storage Account

## Usage

```hcl
module "storage_account" {
  source = "./modules/storage_account"

  name                     = "myappstorageunique"
  resource_group_name      = "myapp-rg"
  location                = "East US"
  account_tier            = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name                       | Description                                           | Type          | Default       | Required |
| -------------------------- | ----------------------------------------------------- | ------------- | ------------- | :------: |
| name                       | Name of the storage account (must be globally unique) | `string`      | n/a           |   yes    |
| resource_group_name        | Name of the resource group                            | `string`      | n/a           |   yes    |
| location                   | Azure region                                          | `string`      | n/a           |   yes    |
| account_tier               | Storage account tier                                  | `string`      | `"Standard"`  |    no    |
| account_replication_type   | Storage account replication type                      | `string`      | `"LRS"`       |    no    |
| account_kind               | Storage account kind                                  | `string`      | `"StorageV2"` |    no    |
| access_tier                | Access tier for the storage account                   | `string`      | `"Hot"`       |    no    |
| blob_delete_retention_days | Blob delete retention days                            | `number`      | `7`           |    no    |
| tags                       | Tags to apply to resources                            | `map(string)` | `{}`          |    no    |

## Outputs

| Name                        | Description                 |
| --------------------------- | --------------------------- |
| id                          | ID of the storage account   |
| name                        | Name of the storage account |
| primary_access_key          | Primary access key          |
| secondary_access_key        | Secondary access key        |
| primary_connection_string   | Primary connection string   |
| secondary_connection_string | Secondary connection string |
| primary_blob_endpoint       | Primary blob endpoint       |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |

## Notes

- The storage account name must be globally unique across Azure
- Name must be 3-24 characters long and contain only lowercase letters and numbers
- Blob delete retention is configured by default
