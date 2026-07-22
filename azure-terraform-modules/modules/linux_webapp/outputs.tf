output "webapp_id" {
  description = "The ID of the Linux Web App."
  value       = azurerm_linux_web_app.this.id
}

output "webapp_name" {
  description = "The name of the Linux Web App."
  value       = azurerm_linux_web_app.this.name
}

output "default_site_hostname" {
  description = "The default hostname of the Linux Web App."
  value       = azurerm_linux_web_app.this.default_hostname
}
