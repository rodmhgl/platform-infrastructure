terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    resource_group {
      prevent_deletion_if_contains_resources = var.prevent_rg_deletion
    }
  }
}

provider "azuread" {}
