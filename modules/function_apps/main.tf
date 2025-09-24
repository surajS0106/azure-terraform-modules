resource "azurerm_linux_function_app" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {
    always_on = var.always_on

    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = var.app_settings

  tags = var.tags
}
