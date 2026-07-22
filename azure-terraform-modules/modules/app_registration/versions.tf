terraform {
  required_version = ">= 1.12.1"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }
  }
}
