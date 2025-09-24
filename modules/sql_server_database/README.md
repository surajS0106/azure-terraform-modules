# SQL Server Database Module

This module creates an Azure SQL Server and Database with configurable settings.

## Resources Created

- `azurerm_mssql_server` - Azure SQL Server
- `azurerm_mssql_database` - Azure SQL Database

## Usage

```hcl
module "sql_server_database" {
  source = "./modules/sql_server_database"

  server_name         = "myapp-sql-server"
  database_name       = "myapp-database"
  resource_group_name = "myapp-rg"
  location           = "East US"
  admin_username     = "sqladmin"
  admin_password     = "SecurePassword123!"

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name                | Description                           | Type          | Default                          | Required |
| ------------------- | ------------------------------------- | ------------- | -------------------------------- | :------: |
| server_name         | Name of the SQL Server                | `string`      | n/a                              |   yes    |
| database_name       | Name of the SQL Database              | `string`      | n/a                              |   yes    |
| resource_group_name | Name of the resource group            | `string`      | n/a                              |   yes    |
| location            | Azure region                          | `string`      | n/a                              |   yes    |
| admin_username      | Administrator username for SQL Server | `string`      | n/a                              |   yes    |
| admin_password      | Administrator password for SQL Server | `string`      | n/a                              |   yes    |
| sql_version         | SQL Server version                    | `string`      | `"12.0"`                         |    no    |
| collation           | Database collation                    | `string`      | `"SQL_Latin1_General_CP1_CI_AS"` |    no    |
| license_type        | License type for the database         | `string`      | `"LicenseIncluded"`              |    no    |
| sku_name            | SKU name for the database             | `string`      | `"S0"`                           |    no    |
| zone_redundant      | Enable zone redundancy                | `bool`        | `false`                          |    no    |
| tags                | Tags to apply to resources            | `map(string)` | `{}`                             |    no    |

## Outputs

| Name              | Description                                   |
| ----------------- | --------------------------------------------- |
| server_id         | ID of the SQL Server                          |
| server_fqdn       | Fully qualified domain name of the SQL Server |
| database_id       | ID of the SQL Database                        |
| connection_string | Connection string for the database            |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |
