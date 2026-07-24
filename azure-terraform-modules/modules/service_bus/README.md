# Service Bus Module

This module provisions an **Azure Service Bus Namespace** and optional **Queues**, **Topics**, and **Subscriptions**.

## Resources created
- `azurerm_servicebus_namespace`
- `azurerm_servicebus_queue` (optional)
- `azurerm_servicebus_topic` (optional)
- `azurerm_servicebus_subscription` (optional)
- `azurerm_servicebus_namespace_authorization_rule` (optional; for shared access keys)

## Usage

```hcl
module "service_bus" {
  source = "./modules/service_bus"

  name                = "myapp-dev-sb"
  location            = "eastus"
  resource_group_name = "rg-myapp-dev"

  sku      = "Standard" # Basic|Standard|Premium
  capacity = 0          # Premium only (1/2/4/8/16)

  local_auth_enabled            = true
  public_network_access_enabled = true
  minimum_tls_version           = "1.2"

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }

  queues = {
    "orders" = {
      max_delivery_count = 10
    }
  }

  topics = {
    "events" = {
      enable_partitioning = true
    }
  }

  subscriptions = {
    "events/sub-all" = {
      topic_name        = "events"
      max_delivery_count = 10
    }
  }

  authorization_rules = {
    "app" = {
      listen = true
      send   = true
      manage = false
    }
  }
}
```

## Notes
- **Basic** SKU does not support Topics/Subscriptions.
- `capacity` is applicable to **Premium** only.
- The `subscriptions` map key is just an identifier; the actual `subscription_name` is derived from the map entry key (or you can use the default behavior).
