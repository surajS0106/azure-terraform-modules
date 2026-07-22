resource "azurerm_mssql_server" "this" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  tags = var.tags
}

resource "azurerm_mssql_database" "this" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.this.id
  collation      = var.collation
  license_type   = var.license_type
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant

  tags = var.tags
}
