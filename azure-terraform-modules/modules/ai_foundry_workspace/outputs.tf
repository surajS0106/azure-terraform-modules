output "workspace_id" {
  description = "ID of the Azure AI Foundry (Azure ML) workspace."
  value       = azurerm_machine_learning_workspace.this.id
}

output "workspace_name" {
  description = "Name of the Azure AI Foundry (Azure ML) workspace."
  value       = azurerm_machine_learning_workspace.this.name
}

output "workspace_identity_principal_id" {
  description = "System-assigned managed identity principal id for the workspace."
  value       = azurerm_machine_learning_workspace.this.identity[0].principal_id
}

output "storage_account_id" {
  description = "Storage account ID used by the workspace."
  value       = var.storage_account_id != null ? var.storage_account_id : azurerm_storage_account.this[0].id
}

output "key_vault_id" {
  description = "Key Vault ID used by the workspace."
  value       = var.key_vault_id != null ? var.key_vault_id : azurerm_key_vault.this[0].id
}

output "application_insights_id" {
  description = "Application Insights ID used by the workspace."
  value       = var.application_insights_id != null ? var.application_insights_id : azurerm_application_insights.this[0].id
}

output "azure_openai_account_id" {
  description = "Azure OpenAI (Cognitive Account) ID, if created."
  value       = try(azurerm_cognitive_account.openai[0].id, null)
}

output "azure_openai_endpoint" {
  description = "Azure OpenAI endpoint, if created."
  value       = try(azurerm_cognitive_account.openai[0].endpoint, null)
}

output "azure_openai_deployment_id" {
  description = "Azure OpenAI deployment ID, if created."
  value       = try(azurerm_cognitive_deployment.gpt[0].id, null)
}
