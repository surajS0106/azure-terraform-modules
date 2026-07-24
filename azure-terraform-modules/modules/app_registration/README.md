# App Registration Module

This module creates an Azure Active Directory App Registration with service principal.

## Resources Created

- `azuread_application` - Azure AD Application
- `azuread_service_principal` - Service Principal
- `azuread_service_principal_password` - Service Principal Password

## Usage

```hcl
module "app_registration" {
  source = "./modules/app_registration"

  display_name = "MyApp Registration"

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

## Variables

| Name              | Description                                 | Type          | Default | Required |
| ----------------- | ------------------------------------------- | ------------- | ------- | :------: |
| display_name      | Display name for the application            | `string`      | n/a     |   yes    |
| password_end_date | End date for the service principal password | `string`      | `null`  |    no    |
| tags              | Tags to apply to resources                  | `map(string)` | `{}`    |    no    |

## Outputs

| Name                        | Description                        |
| --------------------------- | ---------------------------------- |
| application_id              | Application (client) ID            |
| object_id                   | Object ID of the application       |
| service_principal_id        | ID of the service principal        |
| service_principal_object_id | Object ID of the service principal |
| client_secret               | Client secret (sensitive)          |

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |
| azuread   | >= 2.0.0  |

## Notes

- The client secret is marked as sensitive in outputs
- If password_end_date is not specified, the password will be valid for 2 years
- Service principal is automatically created for the application
