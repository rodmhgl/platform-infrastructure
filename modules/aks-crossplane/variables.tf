variable "environment" {
  description = "Environment name (e.g., dev, prod). Used in resource naming."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "Environment must be lowercase alphanumeric with hyphens only."
  }
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "cluster_name_prefix" {
  description = "Prefix for cluster naming. Full name: {prefix}-{environment}"
  type        = string
  default     = "back-stack-aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.34"
}

variable "sku_tier" {
  description = "AKS SKU tier: Free, Standard, or Premium"
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
    node_count = 3
    vm_size    = "Standard_D4s_v3"
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

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
