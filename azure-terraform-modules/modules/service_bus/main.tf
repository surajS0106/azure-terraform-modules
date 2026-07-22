resource "azurerm_servicebus_namespace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku      = var.sku
  capacity = var.capacity

  local_auth_enabled            = var.local_auth_enabled
  public_network_access_enabled = var.public_network_access_enabled
  minimum_tls_version           = var.minimum_tls_version

  tags = var.tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "this" {
  for_each = var.authorization_rules

  name         = each.key
  namespace_id = azurerm_servicebus_namespace.this.id

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

resource "azurerm_servicebus_queue" "this" {
  for_each = var.queues

  name         = each.key
  namespace_id = azurerm_servicebus_namespace.this.id

  lock_duration                       = each.value.lock_duration
  max_delivery_count                  = each.value.max_delivery_count
  max_size_in_megabytes               = each.value.max_size_in_megabytes
  requires_duplicate_detection        = each.value.requires_duplicate_detection
  requires_session                    = each.value.requires_session
  default_message_ttl                 = each.value.default_message_ttl
  dead_lettering_on_message_expiration = each.value.dead_lettering_on_message_expiration
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  enable_partitioning                 = each.value.enable_partitioning
  enable_express                      = each.value.enable_express
  forward_to                          = each.value.forward_to
  forward_dead_lettered_messages_to   = each.value.forward_dead_lettered_messages_to
}

resource "azurerm_servicebus_topic" "this" {
  for_each = var.topics

  name         = each.key
  namespace_id = azurerm_servicebus_namespace.this.id

  default_message_ttl                 = each.value.default_message_ttl
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  enable_batched_operations           = each.value.enable_batched_operations
  enable_express                      = each.value.enable_express
  enable_partitioning                 = each.value.enable_partitioning
  max_size_in_megabytes               = each.value.max_size_in_megabytes
  requires_duplicate_detection        = each.value.requires_duplicate_detection
  support_ordering                    = each.value.support_ordering
}

locals {
  # subscriptions keyed by arbitrary id; value must include topic_name
  subscriptions = var.subscriptions
}

resource "azurerm_servicebus_subscription" "this" {
  for_each = local.subscriptions

  name     = each.value.subscription_name != null ? each.value.subscription_name : replace(each.key, "${each.value.topic_name}/", "")
  topic_id = azurerm_servicebus_topic.this[each.value.topic_name].id

  max_delivery_count = each.value.max_delivery_count
  lock_duration      = each.value.lock_duration
  default_message_ttl = each.value.default_message_ttl
  dead_lettering_on_message_expiration = each.value.dead_lettering_on_message_expiration
  dead_lettering_on_filter_evaluation_exceptions = each.value.dead_lettering_on_filter_evaluation_exceptions
  enable_batched_operations = each.value.enable_batched_operations
  requires_session         = each.value.requires_session
}
