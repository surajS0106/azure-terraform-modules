output "namespace_id" {
  description = "The ID of the Service Bus Namespace."
  value       = azurerm_servicebus_namespace.this.id
}

output "namespace_name" {
  description = "The name of the Service Bus Namespace."
  value       = azurerm_servicebus_namespace.this.name
}

output "namespace_endpoint" {
  description = "The endpoint of the Service Bus Namespace."
  value       = azurerm_servicebus_namespace.this.endpoint
}

output "queue_ids" {
  description = "Map of queue name to queue ID."
  value       = { for k, v in azurerm_servicebus_queue.this : k => v.id }
}

output "topic_ids" {
  description = "Map of topic name to topic ID."
  value       = { for k, v in azurerm_servicebus_topic.this : k => v.id }
}

output "subscription_ids" {
  description = "Map of subscription key to subscription ID."
  value       = { for k, v in azurerm_servicebus_subscription.this : k => v.id }
}

output "authorization_rule_ids" {
  description = "Map of authorization rule name to authorization rule ID."
  value       = { for k, v in azurerm_servicebus_namespace_authorization_rule.this : k => v.id }
}

output "primary_connection_strings" {
  description = "Map of authorization rule name to primary connection string (sensitive)."
  sensitive   = true
  value       = { for k, v in azurerm_servicebus_namespace_authorization_rule.this : k => v.primary_connection_string }
}
