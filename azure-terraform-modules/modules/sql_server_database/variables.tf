variable "server_name" {
  description = "The name of the SQL Server"
  type        = string
}

variable "database_name" {
  description = "The name of the SQL Database"
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

variable "sql_version" {
  description = "The version of SQL Server"
  type        = string
  default     = "12.0"
}

variable "admin_username" {
  description = "The administrator username for the SQL Server"
  type        = string
}

variable "admin_password" {
  description = "The administrator password for the SQL Server"
  type        = string
  sensitive   = true
}

variable "collation" {
  description = "The collation for the SQL Database"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "The license type for the SQL Database"
  type        = string
  default     = "LicenseIncluded"
}

variable "sku_name" {
  description = "The SKU name for the SQL Database"
  type        = string
  default     = "S1"
}

variable "zone_redundant" {
  description = "Whether the SQL Database should be zone redundant"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
