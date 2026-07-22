variable "name" {
  description = "Name of the Service Bus Namespace. Must be globally unique within Azure Service Bus."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where Service Bus will be created."
  type        = string
}

variable "sku" {
  description = "Service Bus SKU: Basic, Standard, or Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of: Basic, Standard, Premium."
  }
}

variable "capacity" {
  description = "Premium capacity. For Premium only: 1,2,4,8,16. Use 0 for Basic/Standard."
  type        = number
  default     = 0

  validation {
    condition     = var.capacity == 0 || contains([1, 2, 4, 8, 16], var.capacity)
    error_message = "capacity must be 0 or one of: 1, 2, 4, 8, 16."
  }
}

variable "minimum_tls_version" {
  description = "The minimum TLS version."
  type        = string
  default     = "1.2"

  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be one of: 1.0, 1.1, 1.2."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled."
  type        = bool
  default     = true
}

variable "local_auth_enabled" {
  description = "Whether SAS key (local auth) is enabled."
  type        = bool
  default     = true
}

variable "queues" {
  description = "Map of queues to create. Key is queue name."
  type = map(object({
    lock_duration                        = optional(string, "PT1M")
    max_delivery_count                   = optional(number, 10)
    max_size_in_megabytes                = optional(number, 1024)
    requires_duplicate_detection         = optional(bool, false)
    requires_session                     = optional(bool, false)
    default_message_ttl                  = optional(string, "P14D")
    dead_lettering_on_message_expiration = optional(bool, true)
    duplicate_detection_history_time_window = optional(string, "PT10M")
    enable_partitioning                  = optional(bool, false)
    enable_express                       = optional(bool, false)
    forward_to                           = optional(string)
    forward_dead_lettered_messages_to    = optional(string)
  }))
  default = {}
}

variable "topics" {
  description = "Map of topics to create. Key is topic name."
  type = map(object({
    default_message_ttl                  = optional(string, "P14D")
    duplicate_detection_history_time_window = optional(string, "PT10M")
    enable_batched_operations            = optional(bool, true)
    enable_express                       = optional(bool, false)
    enable_partitioning                  = optional(bool, false)
    max_size_in_megabytes                = optional(number, 1024)
    requires_duplicate_detection         = optional(bool, false)
    support_ordering                     = optional(bool, true)
  }))
  default = {}
}

variable "subscriptions" {
  description = "Map of subscriptions to create. Each must include topic_name."
  type = map(object({
    topic_name                                = string
    subscription_name                         = optional(string)
    max_delivery_count                        = optional(number, 10)
    lock_duration                             = optional(string, "PT1M")
    default_message_ttl                       = optional(string, "P14D")
    dead_lettering_on_message_expiration      = optional(bool, true)
    dead_lettering_on_filter_evaluation_exceptions = optional(bool, true)
    enable_batched_operations                 = optional(bool, true)
    requires_session                          = optional(bool, false)
  }))
  default = {}
}

variable "authorization_rules" {
  description = "Map of namespace authorization rules (SAS policies) to create."
  type = map(object({
    listen = bool
    send   = bool
    manage = bool
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to the Service Bus Namespace."
  type        = map(string)
  default     = {}
}
