variable "name" {
  description = "The name of the Application Insights component"
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

variable "application_type" {
  description = "The type of application being monitored"
  type        = string
  default     = "web"
}

variable "workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
