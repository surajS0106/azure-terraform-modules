variable "name" {
  description = "Name of the Azure AI Foundry (Azure ML) workspace."
  type        = string
  default     = "suraj"

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 33
    error_message = "Workspace name must be between 3 and 33 characters (Azure ML workspace constraint)."
  }
}

variable "resource_group_name" {
  description = "Resource group name where the workspace and dependent resources will be created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku_name" {
  description = "Azure ML Workspace SKU. Common values: Basic, Enterprise."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Enterprise"], var.sku_name)
    error_message = "sku_name must be one of: Basic, Enterprise."
  }
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

# Optional: bring-your-own IDs
variable "storage_account_id" {
  description = "Existing Storage Account id for the workspace. If null, module creates one."
  type        = string
  default     = null
}

variable "key_vault_id" {
  description = "Existing Key Vault id for the workspace. If null, module creates one."
  type        = string
  default     = null
}

variable "application_insights_id" {
  description = "Existing Application Insights id for the workspace. If null, module creates one."
  type        = string
  default     = null
}

variable "container_registry_id" {
  description = "Existing ACR id for the workspace. If null, module does not create ACR by default (Azure ML can operate without custom ACR for some flows)."
  type        = string
  default     = null
}

# Model deployment (Azure OpenAI) inputs
variable "deploy_model" {
  description = "Whether to create an Azure OpenAI resource + model deployment."
  type        = bool
  default     = true
}

variable "azure_openai_name" {
  description = "Name of the Azure OpenAI account (Cognitive Services). Required if deploy_model=true."
  type        = string
  default     = null
}

variable "azure_openai_sku" {
  description = "SKU for Azure OpenAI account. Typically S0."
  type        = string
  default     = "S0"
}

variable "azure_openai_kind" {
  description = "Kind for the Cognitive account. For Azure OpenAI this is 'OpenAI'."
  type        = string
  default     = "OpenAI"
}

variable "model_deployment_name" {
  description = "Name of the Azure OpenAI deployment."
  type        = string
  default     = "gpt-5-2"
}

variable "model_name" {
  description = "Azure OpenAI model name (as published in your region). Example: 'gpt-5.2' or provider-specific name."
  type        = string
  default     = "gpt-5.2"
}

variable "model_version" {
  description = "Azure OpenAI model version (string). Many models use 'latest'."
  type        = string
  default     = "latest"
}

variable "model_format" {
  description = "Azure OpenAI deployment model format. Typically 'OpenAI'."
  type        = string
  default     = "OpenAI"
}

variable "deployment_scale_type" {
  description = "Scale type for the deployment. Common: 'Standard' (provisioned is separate)."
  type        = string
  default     = "Standard"
}

variable "deployment_capacity" {
  description = "Capacity units for the deployment (for Standard)."
  type        = number
  default     = 10

  validation {
    condition     = var.deployment_capacity >= 1
    error_message = "deployment_capacity must be >= 1."
  }
}
