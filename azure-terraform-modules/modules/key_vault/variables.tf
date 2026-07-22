variable "name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the Key Vault"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "The number of days to retain deleted keys/secrets/certificates"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled"
  type        = bool
  default     = false
}

variable "key_permissions" {
  description = "List of key permissions"
  type        = list(string)
  default     = ["Get", "List", "Create", "Delete", "Update"]
}

variable "secret_permissions" {
  description = "List of secret permissions"
  type        = list(string)
  default     = ["Get", "List", "Set", "Delete"]
}

variable "certificate_permissions" {
  description = "List of certificate permissions"
  type        = list(string)
  default     = ["Get", "List", "Create", "Delete", "Update"]
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
