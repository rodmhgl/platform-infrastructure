terraform {
  required_version = ">= 1.14.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.64"
    }
  }
}

provider "tfe" {
  organization = var.tfc_organization
}
