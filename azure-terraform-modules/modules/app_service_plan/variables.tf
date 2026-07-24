variable "name" {
  description = "The name of the App Service Plan"
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

variable "os_type" {
  description = "The operating system type (Linux or Windows)"
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "The SKU name for the App Service Plan"
  type        = string
  default     = "S1"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
