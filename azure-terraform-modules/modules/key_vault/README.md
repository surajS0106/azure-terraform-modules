# Key Vault Module

This module creates an Azure Key Vault with configurable access policies.

## Resources Created

- `azurerm_key_vault` - Azure Key Vault

## Data Sources

- `azurerm_client_config` - Current Azure client configuration

## Usage

```hcl
module "key_vault" {
  source = "./modules/key_vault"

  name                = "myapp-kv-unique"
  resource_group_name = "myapp-rg"
  location           = "East US"

  key_permissions = [
    "Get", "List", "Create", "Delete", "Update"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete"
  ]

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name                       | Description                                     | Type           | Default                                                                                                                                                            | Required |
| -------------------------- | ----------------------------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------: |
| name                       | Name of the Key Vault (must be globally unique) | `string`       | n/a                                                                                                                                                                |   yes    |
| resource_group_name        | Name of the resource group                      | `string`       | n/a                                                                                                                                                                |   yes    |
| location                   | Azure region                                    | `string`       | n/a                                                                                                                                                                |   yes    |
| sku_name                   | SKU name for the Key Vault                      | `string`       | `"standard"`                                                                                                                                                       |    no    |
| soft_delete_retention_days | Soft delete retention days                      | `number`       | `90`                                                                                                                                                               |    no    |
| purge_protection_enabled   | Enable purge protection                         | `bool`         | `false`                                                                                                                                                            |    no    |
| key_permissions            | Key permissions for the access policy           | `list(string)` | `["Get", "List", "Create", "Delete", "Update", "Recover", "Purge", "GetRotationPolicy"]`                                                                           |    no    |
| secret_permissions         | Secret permissions for the access policy        | `list(string)` | `["Get", "List", "Set", "Delete", "Recover", "Purge"]`                                                                                                             |    no    |
| certificate_permissions    | Certificate permissions for the access policy   | `list(string)` | `["Get", "List", "Create", "Delete", "Update", "ManageContacts", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "ManageIssuers", "Recover", "Purge"]` |    no    |
| tags                       | Tags to apply to resources                      | `map(string)`  | `{}`                                                                                                                                                               |    no    |

## Outputs

| Name      | Description                |
| --------- | -------------------------- |
| id        | ID of the Key Vault        |
| name      | Name of the Key Vault      |
| vault_uri | URI of the Key Vault       |
| tenant_id | Tenant ID of the Key Vault |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |

## Notes

- The Key Vault name must be globally unique across Azure
- The module automatically grants access to the current Azure client (user/service principal)
- Soft delete is enabled by default with 90-day retention
