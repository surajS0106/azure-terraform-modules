variable "name" {
  description = "The name of the Linux Web App."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure location."
  type        = string
}

variable "app_service_plan_id" {
  description = "The ID of the App Service Plan."
  type        = string
}

variable "app_settings" {
  description = "App settings for the web app."
  type        = map(string)
  default     = {}
}
