locals {
  environments = {
    dev = {
      subscription_id     = var.dev_subscription_id
      sku_tier            = "Free"
      prevent_rg_deletion = false
      auto_apply          = true
      terraform_version   = "~> 1.14.0"
    }
    prod = {
      subscription_id     = var.prod_subscription_id
      sku_tier            = "Standard"
      prevent_rg_deletion = true
      auto_apply          = false
      terraform_version   = "~> 1.14.0"
    }
  }
}

# Workspaces
resource "tfe_workspace" "env" {
  for_each = local.environments

  name              = "${var.project_name}-${each.key}"
  organization      = var.tfc_organization
  auto_apply        = each.value.auto_apply
  queue_all_runs    = false
  terraform_version = each.value.terraform_version
  working_directory = var.working_directory

  vcs_repo {
    branch         = var.vcs_branch
    identifier     = var.github_repository
    oauth_token_id = var.github_oauth_token_id
  }
}

# Shared Variable Set - Azure Authentication
resource "tfe_variable_set" "azure_auth" {
  name         = "${var.project_name}-azure-auth"
  description  = "Azure authentication credentials shared across environments"
  organization = var.tfc_organization
}

resource "tfe_variable" "arm_client_id" {
  key             = "ARM_CLIENT_ID"
  value           = var.arm_client_id
  category        = "env"
  variable_set_id = tfe_variable_set.azure_auth.id
  sensitive       = true
}

resource "tfe_variable" "arm_client_secret" {
  key             = "ARM_CLIENT_SECRET"
  value           = var.arm_client_secret
  category        = "env"
  variable_set_id = tfe_variable_set.azure_auth.id
  sensitive       = true
}

resource "tfe_variable" "arm_tenant_id" {
  key             = "ARM_TENANT_ID"
  value           = var.arm_tenant_id
  category        = "env"
  variable_set_id = tfe_variable_set.azure_auth.id
  sensitive       = true
}

# Attach Azure auth to all workspaces
resource "tfe_workspace_variable_set" "azure_auth" {
  for_each = tfe_workspace.env

  variable_set_id = tfe_variable_set.azure_auth.id
  workspace_id    = each.value.id
}

# Environment-specific Variable Sets
resource "tfe_variable_set" "env" {
  for_each = local.environments

  name         = "${var.project_name}-${each.key}-vars"
  description  = "Environment-specific variables for ${each.key}"
  organization = var.tfc_organization
}

resource "tfe_variable" "environment" {
  for_each = local.environments

  key             = "environment"
  value           = each.key
  category        = "terraform"
  variable_set_id = tfe_variable_set.env[each.key].id
}

resource "tfe_variable" "subscription_id" {
  for_each = local.environments

  key             = "subscription_id"
  value           = each.value.subscription_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.env[each.key].id
  sensitive       = true
}

resource "tfe_variable" "arm_subscription_id" {
  for_each = local.environments

  key             = "ARM_SUBSCRIPTION_ID"
  value           = each.value.subscription_id
  category        = "env"
  variable_set_id = tfe_variable_set.env[each.key].id
  sensitive       = true
}

resource "tfe_variable" "sku_tier" {
  for_each = local.environments

  key             = "sku_tier"
  value           = each.value.sku_tier
  category        = "terraform"
  variable_set_id = tfe_variable_set.env[each.key].id
}

resource "tfe_variable" "prevent_rg_deletion" {
  for_each = local.environments

  key             = "prevent_rg_deletion"
  value           = each.value.prevent_rg_deletion
  hcl             = true
  category        = "terraform"
  variable_set_id = tfe_variable_set.env[each.key].id
}

# Attach environment variable sets to respective workspaces
resource "tfe_workspace_variable_set" "env" {
  for_each = local.environments

  variable_set_id = tfe_variable_set.env[each.key].id
  workspace_id    = tfe_workspace.env[each.key].id
}

resource "tfe_run_trigger" "prod_after_dev" {
  count = var.prod_after_dev_trigger_enabled ? 1 : 0

  sourceable_id = tfe_workspace.env["dev"].id
  workspace_id  = tfe_workspace.env["prod"].id
}