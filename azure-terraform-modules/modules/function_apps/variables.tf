variable "name" {
  description = "The name of the Function App"
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

variable "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account for the Function App"
  type        = string
}

variable "storage_account_access_key" {
  description = "The access key for the storage account"
  type        = string
  sensitive   = true
}

variable "always_on" {
  description = "Should the Function App be always on"
  type        = bool
  default     = false
}

variable "node_version" {
  description = "The Node.js version for the Function App"
  type        = string
  default     = "18"
}

variable "app_settings" {
  description = "App settings for the Function App"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
