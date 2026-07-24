# ai_foundry_workspace

Creates an **Azure AI Foundry workspace** (implemented via `azurerm_machine_learning_workspace`) and optionally provisions an **Azure OpenAI** account plus a **model deployment** (intended for “GPT 5.2”).

## Resources
- `azurerm_machine_learning_workspace`
- (optional) `azurerm_cognitive_account` (kind = `OpenAI`)
- (optional) `azurerm_cognitive_deployment`
- (optional, created if not provided) `azurerm_storage_account`
- (optional, created if not provided) `azurerm_key_vault`
- (optional, created if not provided) `azurerm_application_insights`

## Notes / prerequisites
- **Azure OpenAI availability & model naming is region/tenant dependent.** You may need to adjust `model_name`, `model_version`, and `deployment_capacity` to match what’s available in your subscription/region.
- This module creates minimal dependencies for the workspace. For production, consider private endpoints, CMK, diagnostic settings, and network isolation.

## Example
```hcl
module "ai_foundry" {
  source = "./modules/ai_foundry_workspace"

  name                = "myproj-dev-aif"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku_name = "Basic"

  deploy_model           = true
  azure_openai_name      = "myproj-dev-openai"
  model_deployment_name  = "gpt-5-2"
  model_name             = "gpt-5.2"
  model_version          = "latest"
  deployment_capacity    = 10

  tags = {
    environment = "dev"
    project     = "myproj"
  }
}
```
