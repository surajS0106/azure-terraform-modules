output "application_id" {
  description = "The Application (Client) ID"
  value       = azuread_application.this.client_id
}

output "object_id" {
  description = "The Object ID of the application"
  value       = azuread_application.this.object_id
}

output "service_principal_id" {
  description = "The Object ID of the service principal"
  value       = azuread_service_principal.this.object_id
}
