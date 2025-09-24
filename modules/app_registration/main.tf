resource "azuread_application" "this" {
  display_name = var.display_name
  owners       = var.owners

  web {
    redirect_uris = var.redirect_uris
  }

  dynamic "required_resource_access" {
    for_each = length(var.required_permissions) > 0 ? [1] : []
    content {
      resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

      dynamic "resource_access" {
        for_each = var.required_permissions
        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
  owners    = var.owners
}
