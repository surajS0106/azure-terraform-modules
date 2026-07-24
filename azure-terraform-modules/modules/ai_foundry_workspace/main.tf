data "azurerm_client_config" "current" {}

locals {
  create_storage = var.storage_account_id == null
  create_kv      = var.key_vault_id == null
  create_ai      = var.application_insights_id == null

  # Basic normalization for storage account naming constraints (lowercase, 3-24, alphanumeric)
  sa_name = substr(replace(lower("${var.name}sa"), "-", ""), 0, 24)
  kv_name = substr(lower(replace("${var.name}-kv", "_", "-")), 0, 24)
}

resource "azurerm_storage_account" "this" {
  count = local.create_storage ? 1 : 0

  name                     = local.sa_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false

  min_tls_version = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }

  tags = var.tags
}

resource "azurerm_key_vault" "this" {
  count = local.create_kv ? 1 : 0

  name                = local.kv_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  tags = var.tags
}

resource "azurerm_application_insights" "this" {
  count = local.create_ai ? 1 : 0

  name                = "${var.name}-appi"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  tags = var.tags
}

# Azure AI Foundry uses Azure ML Workspace resource in ARM.
resource "azurerm_machine_learning_workspace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.sku_name

  identity {
    type = "SystemAssigned"
  }

  storage_account_id      = local.create_storage ? azurerm_storage_account.this[0].id : var.storage_account_id
  key_vault_id            = local.create_kv ? azurerm_key_vault.this[0].id : var.key_vault_id
  application_insights_id = local.create_ai ? azurerm_application_insights.this[0].id : var.application_insights_id

  # Optional
  container_registry_id = var.container_registry_id

  tags = var.tags
}

# Azure OpenAI account + deployment (for "GPT 5.2")
resource "azurerm_cognitive_account" "openai" {
  count = var.deploy_model ? 1 : 0

  name                = coalesce(var.azure_openai_name, "${var.name}-openai")
  location            = var.location
  resource_group_name = var.resource_group_name

  kind     = var.azure_openai_kind
  sku_name = var.azure_openai_sku

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_cognitive_deployment" "gpt" {
  count = var.deploy_model ? 1 : 0

  name                 = var.model_deployment_name
  cognitive_account_id = azurerm_cognitive_account.openai[0].id

  model {
    format  = var.model_format
    name    = var.model_name
    version = var.model_version
  }

  scale {
    type     = var.deployment_scale_type
    capacity = var.deployment_capacity
  }
}
