# TFC Organization
variable "tfc_organization" {
  description = "Terraform Cloud organization name"
  type        = string
}

# VCS Configuration
variable "github_oauth_token_id" {
  description = "OAuth token ID for GitHub VCS connection (find in TFC Organization Settings > VCS Providers)"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository identifier (e.g., 'rodmhgl/platform-infrastructure')"
  type        = string
  default     = "rodmhgl/platform-infrastructure"
}

variable "vcs_branch" {
  description = "VCS branch to track"
  type        = string
  default     = "main"
}

variable "working_directory" {
  description = "Working directory within the repository"
  type        = string
  default     = ""
}

# Azure Authentication
variable "arm_client_id" {
  description = "Azure Service Principal Client ID"
  type        = string
  sensitive   = true
}

variable "arm_client_secret" {
  description = "Azure Service Principal Client Secret"
  type        = string
  sensitive   = true
}

variable "arm_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}

# Environment-specific Azure Subscriptions
variable "dev_subscription_id" {
  description = "Azure Subscription ID for dev environment"
  type        = string
  sensitive   = true
}

variable "prod_subscription_id" {
  description = "Azure Subscription ID for prod environment"
  type        = string
  sensitive   = true
}

# Project naming
variable "project_name" {
  description = "Project name prefix for workspaces"
  type        = string
  default     = "back-stack"
}

variable "prod_after_dev_trigger_enabled" {
  description = "Enable promotion from dev to prod environment"
  type        = bool
  default     = true
}
