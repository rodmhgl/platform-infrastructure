# Provider configuration
variable "subscription_id" {
  description = "Azure subscription ID for deployment"
  type        = string
}

variable "prevent_rg_deletion" {
  description = "Prevent deletion of resource groups containing resources. Defaults to true (production-safe). Set to false for dev workspaces."
  type        = bool
  default     = true
}

# Environment and naming
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod). Used in resource naming and tagging."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "Environment must be lowercase alphanumeric with hyphens only."
  }
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus2"
}

variable "cluster_name_prefix" {
  description = "Prefix for cluster naming. Full name: {prefix}-{environment}"
  type        = string
  default     = "back-stack-aks"
}

# Kubernetes configuration
variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster (e.g., \"1.31.3\"). Set to null to use AKS default."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "AKS SKU tier: Free (dev/test), Standard (production), or Premium"
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "SKU tier must be Free, Standard, or Premium."
  }
}

variable "default_node_pool" {
  description = "Configuration for the default (system) node pool"
  type = object({
    node_count      = number
    vm_size         = string
    os_disk_size_gb = optional(number, 128)
    os_disk_type    = optional(string, "Managed")
    max_pods        = optional(number, 110)
    max_surge       = optional(string, "33%")
  })
  default = {
    node_count = 2
    vm_size    = "Standard_D2s_v3"
  }
}

variable "network_profile" {
  description = "Network profile configuration for AKS"
  type = object({
    network_plugin    = optional(string, "azure")
    network_policy    = optional(string, "azure")
    load_balancer_sku = optional(string, "standard")
    service_cidr      = optional(string, "10.0.0.0/16")
    dns_service_ip    = optional(string, "10.0.0.10")
  })
  default = {}
}

# Crossplane configuration
variable "crossplane_namespace" {
  description = "Kubernetes namespace where Crossplane provider runs"
  type        = string
  default     = "crossplane-system"
}

variable "crossplane_service_account" {
  description = "Service account name for Crossplane Azure provider"
  type        = string
  default     = "provider-azure"
}

# Tagging
variable "tags" {
  description = "Additional tags for all resources (merged with default tags)"
  type        = map(string)
  default     = {}
}