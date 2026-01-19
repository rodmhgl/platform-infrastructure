variable "subscription_id" {
  description = "Azure subscription ID for deployment"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus2"
}

variable "cluster_name_prefix" {
  description = "Prefix for cluster naming"
  type        = string
  default     = "back-stack-aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.34"
}
